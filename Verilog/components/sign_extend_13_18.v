module sign_extend_13_18 (
    input  wire [12:0] in,
    output wire [17:0] extended_out
);
    assign extended_out = {{5{in[12]}}, in};
endmodule
