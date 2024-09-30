# FIFO Verification using SystemVerilog
This repository contains a SystemVerilog project for the verification of a First-In-First-Out (FIFO) design. The project was verified by Khaled Ahmed Hamed, under the supervision of Eng. Kareem Waseem.

![image](https://github.com/user-attachments/assets/829c5e52-534d-425b-adc0-e46a71381174)

### Project Overview
This project focuses on verifying a FIFO design with the following key attributes:

Depth: Configurable FIFO depth.
Flags: Full, empty, almost full, overflow, and underflow flags.
Write and Read Control: Logic to handle data flow based on control signals wr_enable, rd_enable, and rst_n.

#### Known Design Bugs
The FIFO design contains four known bugs that were targeted during verification:

Reset Signal Overflow & Underflow: Issues related to incorrect flag behaviors on reset:
wr_ack and underflow have faulty behaviors during reset.
Unhandled Cases:
If both read_enable and write_enable are high and the FIFO is empty, only writing should occur.
If both read_enable and write_enable are high and the FIFO is full, only reading should occur.
Sequential Underflow Flag: The underflow flag is sequential when it should be combinational.
Almost Full Flag Miscalculation: The flag for "almost full" status was initially calculated as FIFO_DEPTH-2, and was corrected to FIFO_DEPTH-1.

### Verification Plan
Key Verification Goals
The goal of this verification project is to achieve comprehensive coverage of the FIFO design using constrained-random testbench and directed tests. The verification process checks for correct flag operations, data handling, and boundary conditions.

### RTL Assertions
Several RTL assertions were implemented to ensure that the FIFO flags and pointers behave correctly under different scenarios, such as reset, overflow, underflow, read, and write operations.

### Interface Code
The project uses a SystemVerilog interface for connecting the testbench components with the DUT (Device Under Test). This interface simplifies signal handling and helps to verify the communication between different testbench components.

### Monitor
A dedicated monitor module tracks the transactions between the DUT and the testbench, ensuring the inputs and outputs behave as expected. The monitor also logs transaction information for further analysis.

### Testbench
The testbench is self-checking, using random and directed stimuli to test the FIFO under a wide range of conditions. A scoreboard compares the expected results with the actual outputs from the DUT. The testbench is designed to handle:

### Coverage
The verification methodology employed functional coverage to ensure that all corner cases and important scenarios were tested. The coverage model includes:

#### Code Coverage: Including toggle, branch, statement, and condition coverage.

#### Assertion Coverage: Ensuring that all RTL assertions were exercised.
#### Functional Coverage: Using a covergroup to measure the effectiveness of the testbench in exercising different FIFO states (e.g., full, almost full, empty).

Label1: When rst_n is asserted, all flags and internal signals should be reset to 0.
Label2: When rst_n is deactivated and the FIFO is full (count = depth), the full flag should be high.
Label3: When rst_n is deactivated and the FIFO has one free slot (count = depth-1), the almostfull flag should be high.
Label4: When rst_n is deactivated and the FIFO is empty (count = 0), the empty flag should be high.
Label5: When rst_n is deactivated and the FIFO has only one element (count = 1), the empty flag should still be high.
Label6: When rst_n is deactivated and a write occurs while the FIFO is not full, the wr_ack flag should be high, and the wr_ptr should increment.
Label7: When rst_n is deactivated and a write occurs while the FIFO is full, the overflow flag should be high.
Label8: When rst_n is deactivated and a read occurs while the FIFO is not empty, the rd_ptr should increment, and data_out should match mem[rd_ptr].
Label9: When rst_n is deactivated and a read occurs while the FIFO is empty, the underflow flag should be high.
At the end of the simulation, the FIFO is empty, indicating that all transactions were processed correctly.

#### Overall Coverage
Toggle Coverage: Measures how often each bit in the design toggles.
Branch Coverage: Ensures all branches in conditional statements are exercised.
Statement Coverage: Verifies all code statements are executed.
Condition Coverage: Ensures that all conditions in the design have been evaluated.
Assertions Coverage: Tracks how many of the implemented assertions have been triggered.
Functional Coverage: Cross-coverage between write enable, read enable, and control signals (excluding data_out).

### Simulation Results
The FIFO verification was conducted using QuestaSim. Several key test cases and scenarios were simulated, and the following results were captured:

### Conclusion
This project successfully verified the FIFO design, uncovering key bugs and ensuring the correct operation of the FIFO under various scenarios, including corner cases.
