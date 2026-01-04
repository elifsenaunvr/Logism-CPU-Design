module data_memory #(
    parameter DEPTH = 4096
)(
    input  wire        clk,
    input  wire        MemWrite,
    input  wire        MemRead,
    input  wire [11:0] Address,
    input  wire [17:0] DataInput,
    output wire [17:0] DataOutput
);
    reg [17:0] mem [0:DEPTH-1];

    always @(posedge clk) begin
        if (MemWrite) begin
            mem[Address] <= DataInput;
        end
    end

    assign DataOutput = (MemRead) ? mem[Address] : 18'b0;

endmodule
