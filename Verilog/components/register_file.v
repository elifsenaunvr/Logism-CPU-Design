module register_file (
    input  wire        clk,
    input  wire        reset,
    input  wire        RegWrite,
    input  wire [3:0]  write_addr,
    input  wire [17:0] write_data,
    input  wire [3:0]  rs1,
    input  wire [3:0]  rs2,
    output wire [17:0] rd1,
    output wire [17:0] rd2
);
    reg [17:0] regs [0:15];
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i=0; i<16; i=i+1) regs[i] <= 18'b0;
        end else if (RegWrite) begin
            regs[write_addr] <= write_data;
        end
    end

    assign rd1 = regs[rs1];
    assign rd2 = regs[rs2];
endmodule
