module arith_unit(
    input [15:0] A,
    input [15:0] B,
    input [1:0] sel, // 2 bit
    output reg [15:0] Y,
    output reg        cout
);
reg [31:0] product;


always @(*) begin //arithmetic unit
//default case

//implement truth table
    case(sel)
    default: begin
    Y = 16'h0000;
    cout = 1'b0;
    product = 32'h00000000;
    end
        2'b00: begin
            product = A*B; //MUL
            Y = product[15:0];
            cout = 1'b0;
            end   
        2'b01:begin        //ADD
               {cout,Y} = A+B;
               end
               
        2'b10: begin
              {cout, Y} = A-B; //SUB
               end
               
        2'b11: begin
               {cout, Y} = A + 16'h0001;//INC
               end
    endcase
end

endmodule