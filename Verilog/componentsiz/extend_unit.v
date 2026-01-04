// Extend Unit Module
// Extends 5-bit immediate to 18-bit based on ExtSel signal
module extend_unit (
    input  wire [4:0]  imm,
    input  wire        ExtSel,
    output wire [17:0] ExtImm
);

// Sign-extend or zero-extend based on ExtSel
assign ExtImm = (ExtSel == 1'b0) ?
                {{13{imm[4]}}, imm} :
                {13'b0, imm};

endmodule
