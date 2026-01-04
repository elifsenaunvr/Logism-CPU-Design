module program_counter (
    input  wire        clk,
    input  wire        reset,
    input  wire        PC_Write,
    input  wire        PC_Src,
    input  wire [11:0] PC_offset,
    output wire [11:0] PC_out
);
    wire [11:0] pc_q;

    wire [11:0] pc_plus1   = pc_q + 12'd1;
    wire [11:0] pc_plusofs = pc_plus1 + PC_offset;

    wire [11:0] pc_next = (PC_Src) ? pc_plusofs : pc_plus1;

    registerN_struct #(12) PCREG (
        .clk     (clk),
        .reset   (reset),
        .enable  (PC_Write),
        .data_in (pc_next),
        .data_out(pc_q)
    );

    assign PC_out = pc_q;

endmodule
