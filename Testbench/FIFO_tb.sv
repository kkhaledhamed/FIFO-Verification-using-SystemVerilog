import shared_pkg::*;
import FIFO_transaction_pkg::*;
import FIFO_coverage_pkg::*;
import FIFO_scoreboard::*;


module FIFO_tb (FIFO_interface.TEST FIFO_IF);

	FIFO_transaction trans_obj_tb = new();
	initial begin
		 // Initialize signals
		 FIFO_IF.rst_n=0; FIFO_IF.rd_en=0; FIFO_IF.wr_en=0; FIFO_IF.data_in=0;
		 @(negedge FIFO_IF.clk);
		 FIFO_IF.rst_n=1;
		 @(negedge FIFO_IF.clk);

		 // Testing
		 repeat(10_000) begin
		 	assert(trans_obj_tb.randomize());
		 	FIFO_IF.rst_n=trans_obj_tb.rst_n;
		 	FIFO_IF.rd_en=trans_obj_tb.rd_en;
		 	FIFO_IF.wr_en=trans_obj_tb.wr_en;
		 	FIFO_IF.data_in=trans_obj_tb.data_in;
		 	@(negedge FIFO_IF.clk);
		 end

		  test_finished =1;// Raise flag to stop testing
	end

endmodule : FIFO_tb

