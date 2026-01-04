module extend_unit (
    input  wire [4:0]  imm,
    input  wire        ExtSel,
    output wire [17:0] ExtImm
);
    wire [17:0] s_ext;
    wire [17:0] z_ext;

    sign_extend_5_18 SE(.in(imm), .extended_out(s_ext));
    zero_extend_5_18 ZE(.in(imm), .extended_out(z_ext));

    assign ExtImm = (ExtSel) ? z_ext : s_ext;
endmodule
