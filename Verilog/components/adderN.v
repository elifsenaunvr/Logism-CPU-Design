module adderN #(
    parameter N = 18
)(
    input  wire [N-1:0] A,
    input  wire [N-1:0] B,
    input  wire         Cin,
    output wire [N-1:0] Sum,
    output wire         Cout
);

    wire [N:0] c;
    assign c[0] = Cin;

    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : FA_CHAIN
            full_adder fa (
                .a   (A[i]),
                .b   (B[i]),
                .cin (c[i]),
                .sum (Sum[i]),
                .cout(c[i+1])
            );
        end
    endgenerate

    assign Cout = c[N];

endmodule
