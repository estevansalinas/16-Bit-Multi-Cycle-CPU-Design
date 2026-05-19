module ALU(
    input  [15:0] A,
    input  [15:0] B,
    input         mode,
    input  [2:0]  opcode,
    output reg [15:0] result,
    output reg        cout
);

    wire [15:0] logic_out;
    wire [15:0] arith_out;
    wire        arith_cout;
    wire [15:0] shift_out;

    // instantiate your submodules
    logic_unit u_logic (
        .A(A),
        .B(B),
        .opcode(opcode),
        .Y(logic_out)
    );

    // arithmetic sel is opcode[1:0] when mode=1 and opcode is 000-011
    arith_unit u_arith (
        .A(A),
        .B(B),
        .sel(opcode[1:0]),
        .Y(arith_out),
        .cout(arith_cout)
    );

    // shift sel is opcode[1:0] when mode=1 and opcode is 100-111
    shift_unit u_shift (
        .A(A),
        .B(B),
        .sel(opcode[1:0]),
        .Y(shift_out)
    );

    // output select + cout gating
    always @(*) begin
        result = 16'h0000;
        cout   = 1'b0;

        if (mode == 1'b0) begin
            // logic ops: opcode 000-111
            result = logic_out;
            cout   = 1'b0;
        end else begin
            // mode = 1: arithmetic for 000-011, shift for 100-111
            if (opcode[2] == 1'b0) begin
                // 0xx -> arithmetic
                result = arith_out;
                cout   = arith_cout;   // only arithmetic drives cout
            end else begin
                // 1xx -> shift/rotate
                result = shift_out;
                cout   = 1'b0;
            end
        end
    end

endmodule
