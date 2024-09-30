interface FIFO_interface (input bit clk);
	
	// Parameters
	parameter FIFO_WIDTH = 16;
	parameter FIFO_DEPTH = 8;
	localparam max_fifo_addr = $clog2(FIFO_DEPTH);

	// Signals
	logic [FIFO_WIDTH-1:0] data_in;
	logic rst_n, wr_en, rd_en;
	logic [FIFO_WIDTH-1:0] data_out;
	logic wr_ack, overflow, underflow;
	logic full, empty, almostfull, almostempty;
	
	// Modports
	modport DUT (input clk, data_in, rst_n, wr_en, rd_en, output data_out, wr_ack, overflow, underflow, full, empty, almostfull, almostempty);

	modport TEST (output data_in, rst_n, wr_en, rd_en,input clk, data_out, wr_ack, overflow, underflow, full, empty, almostfull, almostempty);

	modport MONITOR (input clk, data_in, rst_n, wr_en, rd_en, data_out, wr_ack, overflow, underflow, full, empty, almostfull, almostempty);

endinterface : FIFO_interface