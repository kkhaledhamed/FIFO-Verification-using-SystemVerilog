import shared_pkg::*;
import FIFO_transaction_pkg::*;
import FIFO_coverage_pkg::*;
import FIFO_scoreboard::*;

module FIFO_monitor(FIFO_interface.MONITOR FIFO_IF);

	FIFO_transaction trans_obj;
	FIFO_coverage cvg_obj;
	FIFO_scoreboard score_obj;

	initial begin
		trans_obj=new(); cvg_obj=new(); score_obj=new();

		forever begin
			@(negedge FIFO_IF.clk);
			// Sampling IO signals
			trans_obj.rd_en=FIFO_IF.rd_en;
			trans_obj.wr_en=FIFO_IF.wr_en;
			trans_obj.rst_n=FIFO_IF.rst_n;
			trans_obj.data_in=FIFO_IF.data_in;
			trans_obj.data_out=FIFO_IF.data_out;
			trans_obj.wr_ack=FIFO_IF.wr_ack;
			trans_obj.overflow=FIFO_IF.overflow;
			trans_obj.underflow=FIFO_IF.underflow;
			trans_obj.full=FIFO_IF.full;
			trans_obj.almostfull=FIFO_IF.almostfull;
			trans_obj.empty=FIFO_IF.empty;
			trans_obj.almostempty=FIFO_IF.almostempty;

			fork
			// First process
			begin
				cvg_obj.sample_data(trans_obj);
			end
			// Second process
			begin
				score_obj.check_data(trans_obj);
			end
			join

		if (test_finished) begin
			$display("The test has finished, Correct counts: %d, Error counts: %d",correct_counter, error_counter);
			$display("The FIFO contents at the end is: %p", score_obj.fifo_queue);
			$stop;
		end
		end
		
	end
endmodule