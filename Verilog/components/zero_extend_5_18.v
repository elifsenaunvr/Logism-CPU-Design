module zero_extend_5_18 (
    input  wire [4:0]  in,
    output wire [17:0] extended_out
);
    assign extended_out = {13'b0, in};
endmodule
