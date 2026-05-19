module logic_unit(
    input [15:0] A,
    input [15:0] B,
    input [2:0] opcode,
    output reg [15:0] Y //Y will be assigned inside an always block. Anything assigned in always must be a reg
);
always @(*) begin //logic unit is combinational hardware. Output changes immediately when inputs change
    Y = 16'h0000; //default function; without this verilog would assume a latch. No memory should be in logic unit
    //implement truth table
    case (opcode)
        3'b000: Y = A&B;    //AND
        3'b001: Y = A|B;    //OR
        3'b010: Y = A ^ B;  //XOR
        3'b011: Y = ~(A&B); //NAND
        3'b100: Y = ~(A|B); //NOR
        3'b101: Y = ~(A^B); //XNOR
        3'b110: Y = ~A;     //NOT A
        3'b111: Y = ~B;     //NOT B
    endcase
end

endmodule
