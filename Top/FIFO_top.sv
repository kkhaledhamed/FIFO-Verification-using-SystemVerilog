module FIFO_top ();

	bit clk;
	// Clock generation
	initial begin
		clk=0;
		forever 
			#1 clk = ~clk;// Clock period = 2ns
	end

	// Instantiations
	FIFO_interface FIFO_IF (clk);

	FIFO FIFO_DUT (FIFO_IF);

	FIFO_tb FIFO_TB (FIFO_IF);

	FIFO_monitor FIFO_MON (FIFO_IF);
endmodule 