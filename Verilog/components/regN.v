module regN #(
    parameter N = 18
)(
    input  wire         clk,
    input  wire         reset,
    input  wire         enable,
    input  wire [N-1:0] data_in,
    output wire [N-1:0] data_out
);

    wire [N-1:0] q;
    assign data_out = q;

    // Final D input for flip-flops
    wire [N-1:0] d_next;

    assign d_next = reset  ? {N{1'b0}} :
                    enable ? data_in   :
                             q;

    // D Flip-Flops
    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : FF
            wire qn_unused;
            d_flip_flop dff (
                .D   (d_next[i]),
                .Clk (clk),
                .Q   (q[i]),
                .Qn  (qn_unused)
            );
        end
    endgenerate

endmodule
