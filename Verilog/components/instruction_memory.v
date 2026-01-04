module instruction_memory #(
    parameter DEPTH   = 4096,
    parameter MEMFILE = "program.hex"
)(
    input  wire [11:0] PC_Address,
    output wire [17:0] instr
);
    reg [17:0] mem [0:DEPTH-1];

    initial begin
        $readmemh(MEMFILE, mem);
    end

    assign instr = mem[PC_Address];
endmodule
