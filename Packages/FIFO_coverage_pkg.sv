package FIFO_coverage_pkg;
import FIFO_transaction_pkg::*;
	class FIFO_coverage;

		FIFO_transaction F_cvg_txn = new();

		covergroup cg;
			
			// Coverpoints
			wr_en_cp: coverpoint F_cvg_txn.wr_en;
			rd_en_cp: coverpoint F_cvg_txn.rd_en;
			wr_ack_cp: coverpoint F_cvg_txn.wr_ack;
			overflow_cp: coverpoint F_cvg_txn.overflow;
			underflow_cp: coverpoint F_cvg_txn.underflow;
			full_cp: coverpoint F_cvg_txn.full;
			almostfull_cp: coverpoint F_cvg_txn.almostfull;
			empty_cp: coverpoint F_cvg_txn.empty;
			almostempty_cp: coverpoint F_cvg_txn.almostempty;

			// Crosses
			WRITE_READ_WR_ACK_CROSS: cross wr_en_cp, rd_en_cp, wr_ack_cp{
				ignore_bins WRITE0_READ1_WR_ACK1 = binsof(wr_en_cp)intersect{0} && binsof(rd_en_cp)intersect{1} && binsof(wr_ack_cp)intersect{1};
				ignore_bins WRITE0_READ0_WR_ACK1 = binsof(wr_en_cp)intersect{0} && binsof(rd_en_cp)intersect{0} && binsof(wr_ack_cp)intersect{1};
			}
			WRITE_READ_OVERFLOW_CROSS: cross wr_en_cp, rd_en_cp, overflow_cp{
				ignore_bins WRITE0_READ1_OVERFLOW1 = binsof(wr_en_cp)intersect{0} && binsof(rd_en_cp)intersect{1} && binsof(overflow_cp)intersect{1};
				ignore_bins WRITE0_READ0_OVERFLOW1 = binsof(wr_en_cp)intersect{0} && binsof(rd_en_cp)intersect{0} && binsof(overflow_cp)intersect{1};
			}
			WRITE_READ_UNDERFLOW_CROSS: cross wr_en_cp, rd_en_cp, underflow_cp {
				ignore_bins WRITE1_READ0_UNDERFLOW1 = binsof(wr_en_cp)intersect{1} && binsof(rd_en_cp)intersect{0} && binsof(underflow_cp)intersect{1};
				ignore_bins WRITE0_READ0_UNDERFLOW1 = binsof(wr_en_cp)intersect{0} && binsof(rd_en_cp)intersect{0} && binsof(underflow_cp)intersect{1};
			}
			WRITE_READ_FULL_CROSS: cross wr_en_cp, rd_en_cp, full_cp {
				ignore_bins WRITE1_READ1_FULL1 = binsof(wr_en_cp)intersect{1} && binsof(rd_en_cp)intersect{1} && binsof(full_cp)intersect{1};
				ignore_bins WRITE0_READ1_FULL1 = binsof(wr_en_cp)intersect{0} && binsof(rd_en_cp)intersect{1} && binsof(full_cp)intersect{1};
			}
			WRITE_READ_EMPTY_CROSS: cross wr_en_cp, rd_en_cp, empty_cp;
			WRITE_READ_ALMOST_FULL_CROSS: cross wr_en_cp, rd_en_cp, almostfull_cp;
			WRITE_READ_ALMOST_EMPTY_CROSS: cross wr_en_cp, rd_en_cp, almostempty_cp;

		endgroup : cg

		function void sample_data(input FIFO_transaction F_txn);
		F_cvg_txn = F_txn;
		cg.sample();
		endfunction : sample_data

		function new();
			cg=new();
		endfunction : new

	endclass : FIFO_coverage
endpackage : FIFO_coverage_pkg