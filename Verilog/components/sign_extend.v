module sign_extend (
    input  wire [3:0]  in,
    output wire [17:0] extended_out
);
    assign extended_out = {{14{in[3]}}, in};
endmodule
