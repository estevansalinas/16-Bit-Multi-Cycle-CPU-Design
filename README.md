16-Bit Multi-Cycle CPU Design
A 16-bit Arithmetic Logic Unit (ALU) implemented in Verilog and simulated using Vivado xsim. Designed for a Digital System Design course at the University of Houston–Clear Lake.
Overview
The ALU operates in two modes selected by a mode bit, supporting 16 logic operations, 4 arithmetic operations, and 4 shift/rotate operations on 16-bit operands.
Module Hierarchy
ALU (top)
├── logic_unit
├── arith_unit
└── shift_unit
Operation Table
modeopcodeOperation0000AND0001OR0010XOR0011NAND0100NOR0101XNOR0110NOT A0111NOT B1000MUL1001ADD1010SUB1011INC1100SLL1101SRL1110ROL1111ROR
Files
FileDescriptionalu.vTop-level ALU modulelogic_unit.vBitwise logic operationsarith_unit.vArithmetic operations (MUL, ADD, SUB, INC)shift_unit.vShift and rotate operationstb_alu.vTestbench
Tools

Verilog HDL
Xilinx Vivado (simulation via xsim)
