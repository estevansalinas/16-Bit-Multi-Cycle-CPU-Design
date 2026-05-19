`timescale 1ns/1ps
module tb_alu; //module header

//declare signals properly
    reg [15:0] A;
    reg [15:0] B;
    reg        mode;
    reg [2:0]  opcode;
    reg [31:0] prod;
    reg [16:0] temp; //for cout operation
    reg [3:0]  shamt;
    reg [15:0] exp;
    wire [15:0] result;
    wire        cout;

// rotate-left helper (matches your shift_unit)
function [15:0] rol16;
  input [15:0] x;
  input [3:0]  s;
  begin
    if (s == 0) rol16 = x;
    else rol16 = (x << s) | (x >> (16 - s));
  end
endfunction

function [15:0] ror16;
  input [15:0] x;
  input [3:0]  s;
  begin
    if (s == 0) ror16 = x;
    else ror16 = (x >> s) | (x << (16 - s));
  end
endfunction

//instantiate the ALU
ALU dut (
    .A(A),
    .B(B),
    .mode(mode),
    .opcode(opcode),
    .result(result),
    .cout(cout)
);

//check mechanism 
//$display("A=%h B=%h Mode=%b Opcode=%b OUT=%h C=%b", A, B, Mode, Opcode, ALUOut, Cout);



//add stimulus
initial begin  
//AND Test
   A = 16'h000F;
   B = 16'h00F0;
   mode = 1'b0; //logic group
   opcode = 3'b000; //AND
   #10;
   if (result !== (A&B)) $display("FAIL AND");
   else $display("PASS AND");
   #10;
//OR Test
   A = 16'h000F;
   B = 16'hFF50;
   mode = 1'b0; //logic group
   opcode = 3'b001; //OR
   #10;
   if (result !== (A|B)) $display("FAIL OR");
   else $display("PASS OR");
   #10;
//XOR operation
   A = 16'h000F;
   B = 16'h00F0;
   mode = 1'b0; //logic group
   opcode = 3'b010; //xor
   #10;
   if (result !== (A^B)) $display("FAIL XOR");
   else $display("PASS XOR");
   #10;
//NAND Operation
   A = 16'h000F;
   B = 16'h00F0;
   mode = 1'b0; //logic group
   opcode = 3'b011; //NAND
   #10;
   if (result !== (~(A&B))) $display("FAIL NAND");
   else $display("PASS NAND");
   #10;
//NOR operation
   A = 16'h000F;
   B = 16'h00F0;
   mode = 1'b0; //logic group
   opcode = 3'b100; //NOR
   #10;
   if (result !== (~(A|B))) $display("FAIL NOR");
   else $display("PASS NOR");
   #10;
//XNOR operation
   A = 16'h000F;
   B = 16'h00F0;
   mode = 1'b0; //logic group
   opcode = 3'b101; //XNOR
   #10;
   if (result !== (~(A^B))) $display("FAIL XNOR");
   else $display("PASS XNOR");
   #10;
//NOT A operation
   A = 16'h000F;
   B = 16'h00F0;
   mode = 1'b0; //logic group
   opcode = 3'b110; //NOT A
   #10;
   if (result !== (~(A))) $display("FAIL NOT A");
   else $display("PASS NOT A");
   #10;
//NOT B operation
   A = 16'h000F;
   B = 16'h00F0;
   mode = 1'b0; //logic group
   opcode = 3'b111; //not B
   #10;
   if (result !== (~(B))) $display("FAIL NOT B");
   else $display("PASS NOT B");
   #10;
   
//Arithmetic operations

//MUL operation
   A = 16'h0001;
   B = 16'h0005;
   mode = 1'b1; //arithmetic group
   opcode = 3'b000; //MUL
   #10;
   
   prod = A*B;
   if (result !== (prod[15:0])) $display("FAIL MUL");
   else $display("PASS MUL");
   #10;
    
//ADD operation
   A = 16'hFFF0;
   B = 16'h0005;
   mode = 1'b1; //arithmetic group
   opcode = 3'b001; //ADD
   #10;
   temp = A + B;
   if (result !== temp[15:0]) $display("FAIL ADD");
   else $display("PASS ADD");
   #10;
//COUT ADD OPERATION
   A = 16'hFFFF;
   B = 16'h0001;
   mode = 1'b1; //arithmetic group
   opcode = 3'b001; //ADD
   #10;
   
   temp = A+B;
   
   if (result !== temp[15:0] || cout !== temp[16]) $display("FAIL ADD+COUT");
   else $display("PASS ADD+COUT");
   #10;
//SUB operation
   A = 16'hFFF5;
   B = 16'h0005;
   mode = 1'b1; //arithmetic group
   opcode = 3'b010; //SUB
   #10;
   if (result !== (A-B)) $display("FAIL SUB");
   else $display("PASS SUB");
   #10;  
   
//INC operation
   A = 16'hFFF0;
   //B = 16'h0005;
   mode = 1'b1; //arithmetic group
   opcode = 3'b011; //INC
   #10;
   if (result !== (A+16'h0001)) $display("FAIL INC");
   else $display("PASS INC");
   #10;
//COUT INC operation
   A = 16'hFFFF;
   mode = 1'b1; //arithmetic group
   opcode = 3'b011; //INC
   #10;
   temp = A + 16'h0001;
   
   if (result !== temp[15:0] || cout !== temp[16])
     $display("FAIL INC+COUT");
   else 
     $display("PASS INC+COUT");
   #10;
   
//Shift operations

//SLL operation shamt=0
   A = 16'h8001;
   B = 16'h0000; //shamt = 0
   shamt = B[3:0];
   mode = 1'b1; //arithmetic + shift group
   opcode = 3'b100; //SLL
   exp = A << shamt;
   #10;
   if (result !== (exp)) $display("FAIL SLL shamt = 0");
   else $display("PASS SLL shamt = 0");
   #10;

//SLL operation shamt=1
   A = 16'h8001;
   B = 16'h0001; //shamt = 1
   shamt = B[3:0];
   mode = 1'b1; //arithmetic + shift group
   opcode = 3'b100; //SLL
   exp = A << shamt;
   #10;
   if (result !== (exp)) $display("FAIL SLL shamt = 1");
   else $display("PASS SLL shamt = 1");
   #10;

//SRL operation shamt = 0
   A = 16'h8001;
   B = 16'h0000; //shamt = 0
   shamt = B[3:0];
   mode = 1'b1; //arithmetic +shift group
   opcode = 3'b101; //SRL
   exp = A >> shamt;
   #10;
   if (result !== (exp)) $display("FAIL SRL shamt = 0");
   else $display("PASS SRL shamt = 0");
   #10;

//SRL operation shamt = 1
   A = 16'h8001;
   B = 16'h0001; //shamt = 1
   shamt = B[3:0];
   mode = 1'b1; //arithmetic +shift group
   opcode = 3'b101; //SRL
   exp = A >> shamt;
   #10;
   if (result !== (exp)) $display("FAIL SRL shamt = 1");
   else $display("PASS SRL shamt = 1");
   #10;

//ROL operation shamt = 0
   A = 16'h8001;
   B = 16'h0000; //shamt = 0
   shamt = B[3:0];
   mode = 1'b1; //arithmetic+shift group
   opcode = 3'b110; //ROL
   exp = rol16(A,shamt);
   #10;
   if (result !== (exp)) $display("FAIL ROL shamt = 0");
   else $display("PASS ROL shamt = 0");
   #10;
 
//ROL operation shamt = 1
   A = 16'h8001;
   B = 16'h0001; //shamt = 1
   shamt = B[3:0];
   mode = 1'b1; //arithmetic+shift group
   opcode = 3'b110; //ROL
   exp = rol16(A,shamt);
   #10;
   if (result !== (exp)) $display("FAIL ROL shamt = 1");
   else $display("PASS ROL shamt = 1");
   #10;
   
//ROR operation shamt = 0
   A = 16'h8001;
   B = 16'h0000; //shamt = 0
   shamt = B[3:0];
   mode = 1'b1; //arithmetic+shift group
   opcode = 3'b111; //ROR
   exp = ror16(A,shamt);
   #10;
   if (result !== (exp)) $display("FAIL ROR shamt = 0");
   else $display("PASS ROR shamt = 0");
   #10;   
   
//ROR operation shamt = 1
   A = 16'h8001;
   B = 16'h0001; //shamt = 1
   shamt = B[3:0];
   mode = 1'b1; //arithmetic+shift group
   opcode = 3'b111; //ROR
   exp = ror16(A,shamt);
   #10;
   if (result !== (exp)) $display("FAIL ROR shamt = 1");
   else $display("PASS ROR shamt = 1");
   #10;
    $finish;
end


endmodule



