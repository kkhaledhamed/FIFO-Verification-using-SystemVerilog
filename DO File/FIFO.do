vlib work
vlog -f FIFO.list  +cover -covercells +define+SIM
vsim -voptargs=+acc work.FIFO_top -cover -sv_seed random -l sim.FIFO_log
add wave *
add wave -position insertpoint  \
sim:/FIFO_top/FIFO_IF/almostempty \
sim:/FIFO_top/FIFO_IF/almostfull \
sim:/FIFO_top/FIFO_IF/clk \
sim:/FIFO_top/FIFO_IF/data_in \
sim:/FIFO_top/FIFO_IF/data_out \
sim:/FIFO_top/FIFO_IF/empty \
sim:/FIFO_top/FIFO_IF/FIFO_DEPTH \
sim:/FIFO_top/FIFO_IF/FIFO_WIDTH \
sim:/FIFO_top/FIFO_IF/full \
sim:/FIFO_top/FIFO_IF/max_fifo_addr \
sim:/FIFO_top/FIFO_IF/overflow \
sim:/FIFO_top/FIFO_IF/rd_en \
sim:/FIFO_top/FIFO_IF/rst_n \
sim:/FIFO_top/FIFO_IF/underflow \
sim:/FIFO_top/FIFO_IF/wr_ack \
sim:/FIFO_top/FIFO_IF/wr_en
coverage save FIFO.ucdb -onexit 
run -all
#quit -sim
#vcover report FIFO.ucdb -details -annotate -all -output coverage_FIFO_rpt.txt

