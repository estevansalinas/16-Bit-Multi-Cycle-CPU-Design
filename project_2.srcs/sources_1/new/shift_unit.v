module shift_unit(
    input [15:0] A,
    input [15:0] B,
    input [1:0]  sel,
    output reg [15:0] Y
);        

reg [3:0] shamt;

always @(*) begin
    Y = 16'h0000;
    shamt = B[3:0];
    
    case(sel)   
    
    default: begin
     Y = 16'h0000;
     end
     
        2'b00: Y = A << shamt; //SLL
        2'b01: Y = A >> shamt; //SRL
        
        2'b10: begin //ROL
        if (shamt == 0) Y = A;
        else Y = (A << shamt) | (A >> (16 - shamt));
        end
        
        2'b11: begin //ROR
            if (shamt==0) Y = A;
            else Y= (A >> shamt)| (A << (16-shamt));
        end
   endcase
   
end           
        
        
endmodule