module d_flip_flop (
    input  wire D,     // Data input
    input  wire Clk,   // Clock
    output wire Q,     // Output
    output wire Qn     // Inverted output
);

    // Internal signals
    wire Clk_n;        // Inverted clock
    wire Qm, Qmn;     // Master latch outputs

    // Clock inverter
    assign Clk_n = ~Clk;

    // Master latch (active when Clk = 0)
    d_latch master (
        .D(D),
        .C(Clk_n),
        .Q(Qm),
        .Qn(Qmn)
    );

    // Slave latch (active when Clk = 1)
    d_latch slave (
        .D(Qm),
        .C(Clk),
        .Q(Q),
        .Qn(Qn)
    );

endmodule
