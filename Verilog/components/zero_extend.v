module zero_extend (
    input  wire [8:0]  in,
    output wire [11:0] extended_out
);
    assign extended_out = {3'b000, in};
endmodule
