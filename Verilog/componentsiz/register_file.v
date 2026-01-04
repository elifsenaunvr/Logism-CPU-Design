// Register File Module
module register_file (
    input  wire        clk,
    input  wire        reset,

    input  wire        regWrite,
    input  wire [3:0]  writeReg,
    input  wire [17:0] writeData,

    input  wire [3:0]  readReg1,
    input  wire [3:0]  readReg2,
    output wire [17:0] readData1,
    output wire [17:0] readData2
);

    reg [17:0] regs [0:15];

    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 16; i = i + 1)
                regs[i] <= 18'b0;
        end else if (regWrite) begin
            regs[writeReg] <= writeData;
        end
    end

    assign readData1 = regs[readReg1];
    assign readData2 = regs[readReg2];

endmodule
