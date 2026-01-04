module shifter_logical_right (
    input  wire [17:0] data_in,
    input  wire [4:0]  shamt,
    output wire [17:0] data_out
);
    assign data_out = data_in >> shamt;
endmodule
