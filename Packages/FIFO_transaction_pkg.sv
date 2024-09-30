package FIFO_transaction_pkg;
	class FIFO_transaction ;
		// Parameters
		parameter FIFO_WIDTH = 16;
		parameter FIFO_DEPTH = 8;
		localparam max_fifo_addr = $clog2(FIFO_DEPTH);

		// Signals
		rand logic [FIFO_WIDTH-1:0] data_in;
		rand logic rst_n, wr_en, rd_en;
		logic [FIFO_WIDTH-1:0] data_out;
		logic wr_ack, overflow, underflow;
		logic full, empty, almostfull, almostempty;
		/*************Added signals as integers**************/
		integer RD_EN_ON_DIST,WR_EN_ON_DIST;

		// Constructor, let the default of RD_EN_ON_DIST be 30 and WR_EN_ON_DIST be 70
		function new(integer RD_EN_ON_DIST = 30, integer WR_EN_ON_DIST =70);
			this.RD_EN_ON_DIST=RD_EN_ON_DIST;
			this.WR_EN_ON_DIST=WR_EN_ON_DIST;
		endfunction : new

		// Constraints
		constraint rst_constraint {
			rst_n dist {0:/5, 1:/95};//Assert reset less often
		}
		constraint write_constraint {
			// Write enable to be high with distribution of the value WR_EN_ON_DIST and to be low with 100-WR_EN_ON_DIST
			wr_en dist {1:/WR_EN_ON_DIST, 0:/(100-WR_EN_ON_DIST)};
		}
		constraint read_constraint {
			// Read enable to be high with distribution of the value RD_EN_ON_DIST and to be low with 100-RD_EN_ON_DIST
			rd_en dist {1:/RD_EN_ON_DIST, 0:/(100-RD_EN_ON_DIST)}; 
		}
	endclass : FIFO_transaction
endpackage : FIFO_transaction_pkg