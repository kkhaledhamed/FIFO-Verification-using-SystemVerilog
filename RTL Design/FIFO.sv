////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Verification Engineer: Khaled A. Hamed 🫣
// Course: Digital Verification using SV & UVM
// Description: FIFO Design 
////////////////////////////////////////////////////////////////////////////////
module FIFO (FIFO_interface.DUT FIFO_IF);

reg [FIFO_IF.max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [FIFO_IF.max_fifo_addr:0] count;

reg [FIFO_IF.FIFO_WIDTH-1:0] mem [FIFO_IF.FIFO_DEPTH-1:0];

always @(posedge FIFO_IF.clk or negedge FIFO_IF.rst_n) begin
	if (!FIFO_IF.rst_n) begin
		wr_ptr <= 0;
		// Bug detected: Reset signals FIFO_IF.overflow & FIFO_IF.wr_ack
		FIFO_IF.overflow <= 0;
		FIFO_IF.wr_ack <= 0;
	end
	else if (FIFO_IF.wr_en && count < FIFO_IF.FIFO_DEPTH) begin
		mem[wr_ptr] <= FIFO_IF.data_in;
		FIFO_IF.wr_ack<=1;                                               
		wr_ptr <= wr_ptr + 1;
	end
	else begin 
		FIFO_IF.wr_ack <= 0; 
		if (FIFO_IF.full & FIFO_IF.wr_en)
			FIFO_IF.overflow <= 1;
		else
			FIFO_IF.overflow <= 0;
	end
end

always @(posedge FIFO_IF.clk or negedge FIFO_IF.rst_n) begin
	if (!FIFO_IF.rst_n) begin
		rd_ptr <= 0;
		// Bug detected: Reset signals FIFO_IF.underflow 
		FIFO_IF.underflow <= 0;
	end
	else if (FIFO_IF.rd_en && count != 0) begin
		FIFO_IF.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
	end
	// Handled FIFO_IF.underflow behaviour when turned from combinational to sequential
	else begin 
		if (FIFO_IF.empty & FIFO_IF.rd_en)
			FIFO_IF.underflow <= 1;
		else
			FIFO_IF.underflow <= 0;
	end
end

always @(posedge FIFO_IF.clk or negedge FIFO_IF.rst_n) begin
	if (!FIFO_IF.rst_n) begin
		count <= 0;
	end
	else begin
		if	( ({FIFO_IF.wr_en, FIFO_IF.rd_en} == 2'b10) && !FIFO_IF.full) 
			count <= count + 1;
		else if ( ({FIFO_IF.wr_en, FIFO_IF.rd_en} == 2'b01) && !FIFO_IF.empty)
			count <= count - 1;
		// Bug detected: Unhandled case,  If a read and write enables were high and the FIFO was FIFO_IF.empty, only writing will take place.
		else if ( ({FIFO_IF.wr_en, FIFO_IF.rd_en} == 2'b11) && FIFO_IF.empty)
			count <= count + 1;
		// Bug detected: Unhandled cases,  If a read and write enables were high and the FIFO was FIFO_IF.full, only reading will take place.
		else if ( ({FIFO_IF.wr_en, FIFO_IF.rd_en} == 2'b11) && FIFO_IF.full)
			count <= count - 1;
	end
end

assign FIFO_IF.full = (count == FIFO_IF.FIFO_DEPTH)? 1 : 0;
assign FIFO_IF.empty = (count == 0)? 1 : 0;
assign FIFO_IF.almostfull = (count == FIFO_IF.FIFO_DEPTH-1)? 1 : 0; // Bug detected: FIFO_IF.FIFO_DEPTH-2 --> FIFO_IF.FIFO_DEPTH-1
assign FIFO_IF.almostempty = (count == 1)? 1 : 0;

// Guarded assertions
`ifdef SIM
	// Properties, Assertions & Covers
	always_comb begin 
		if(!FIFO_IF.rst_n)
		reset_1_assertion: assert final ((!FIFO_IF.wr_ack)&&(!FIFO_IF.overflow)&&(!FIFO_IF.underflow)&&(!wr_ptr)&&(!rd_ptr)&&(!count));
		reset_1_cover: cover final ((!FIFO_IF.wr_ack)&&(!FIFO_IF.overflow)&&(!FIFO_IF.underflow)&&(!wr_ptr)&&(!rd_ptr)&&(!count));
	end

	always_comb begin 
		if((FIFO_IF.rst_n)&&(count == FIFO_IF.FIFO_DEPTH))
		full_assertion: assert final (FIFO_IF.full);
		full_cover: cover (FIFO_IF.full);
	end

	always_comb begin 
		if((FIFO_IF.rst_n)&&(count == 0))
		empty_assertion: assert final (FIFO_IF.empty);
		empty_cover: cover (FIFO_IF.empty);
	end

	always_comb begin 
		if((FIFO_IF.rst_n)&&(count == FIFO_IF.FIFO_DEPTH-1))
		almostfull_assertion: assert final (FIFO_IF.almostfull);
		almostfull_cover: cover (FIFO_IF.almostfull);
	end
 
	always_comb begin 
		if((FIFO_IF.rst_n)&&(count == 1))
		almostempty_assertion: assert final (FIFO_IF.almostempty);
		almostempty_cover: cover (FIFO_IF.almostempty);
	end

	property P1;
		@(posedge FIFO_IF.clk or negedge FIFO_IF.rst_n) 
		(!FIFO_IF.rst_n) |-> ((!FIFO_IF.wr_ack)&&(!FIFO_IF.overflow)&&(!FIFO_IF.underflow)&&(!wr_ptr)&&(!rd_ptr)&&(!count));
	endproperty

	property P2;
		@(posedge FIFO_IF.clk) disable iff(!FIFO_IF.rst_n)
		(FIFO_IF.wr_en && !FIFO_IF.full ) |=> ((FIFO_IF.wr_ack)&&((wr_ptr==$past(wr_ptr)+1)||(wr_ptr==0 && $past(wr_ptr) +1 == 8)));
	endproperty

	property P3;
		@(posedge FIFO_IF.clk) disable iff(!FIFO_IF.rst_n)
		(FIFO_IF.full & FIFO_IF.wr_en) |=> (FIFO_IF.overflow);
	endproperty


	property P4;
		@(posedge FIFO_IF.clk) disable iff(!FIFO_IF.rst_n)
		(FIFO_IF.rd_en && count != 0) |=> ((rd_ptr==$past(rd_ptr)+1)||(rd_ptr==0 && $past(rd_ptr) +1 == 8));
	endproperty 

	property P5;
		@(posedge FIFO_IF.clk) disable iff(!FIFO_IF.rst_n)
		(FIFO_IF.empty & FIFO_IF.rd_en) |=> (FIFO_IF.underflow);
	endproperty
	
	property P6;
		@(posedge FIFO_IF.clk) disable iff(!FIFO_IF.rst_n)
		(({FIFO_IF.wr_en, FIFO_IF.rd_en} == 2'b10) && !FIFO_IF.full)   |=> ((count==$past(count)+1));
	endproperty

	property P7;
		@(posedge FIFO_IF.clk) disable iff(!FIFO_IF.rst_n)
		( ({FIFO_IF.wr_en, FIFO_IF.rd_en} == 2'b01) && !FIFO_IF.empty)  |=> ((count==$past(count)-1));
	endproperty

	property P8;
		@(posedge FIFO_IF.clk) disable iff(!FIFO_IF.rst_n)
		( ({FIFO_IF.wr_en, FIFO_IF.rd_en} == 2'b11) && FIFO_IF.empty)  |=> ((count==$past(count)+1));
	endproperty 

	property P9;
		@(posedge FIFO_IF.clk) disable iff(!FIFO_IF.rst_n)
		( ({FIFO_IF.wr_en, FIFO_IF.rd_en} == 2'b11) && FIFO_IF.full)  |=> ((count==$past(count)-1));
	endproperty

	reset_2_assertion: assert property(P1);
	reset_2_cover: cover property(P1);

	write_assertion: assert property(P2);
	write_cover: cover property(P2);

	overflow_assertion: assert property(P3);
	overflow_cover: cover property(P3);

	read_assertion: assert property(P4);
	read_cover: cover property(P4); 

	underflow_assertion: assert property(P5);
	underflow_cover: cover property(P5);

	write_not_full_assertion: assert property(P6);
	write_not_full_cover: cover property(P6);

	read_not_empty_assertion: assert property(P7);
	read_not_empty_cover: cover property(P7);

	read_write_empty_assertion: assert property(P8);
	read_write_empty_cover: cover property(P8);

	read_write_full_assertion: assert property(P9);
	read_write_full_cover: cover property(P9); 
`endif
endmodule