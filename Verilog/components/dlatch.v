module d_latch (
    input  wire D,   // Data input
    input  wire C,   // Enable (clock)
    output wire Q,   // Output
    output wire Qn   // Inverted output
);

    // Internal wires
    wire D_and_C;
    wire nD_and_C;

    // AND gates
    assign D_and_C  = D & C;
    assign nD_and_C = (~D) & C;

    // NOR latch (cross-coupled)
    assign Q  = ~(D_and_C  | Qn);
    assign Qn = ~(nD_and_C | Q);

endmodule
