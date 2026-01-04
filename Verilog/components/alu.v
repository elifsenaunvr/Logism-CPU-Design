module alu (
    input  wire [17:0] A,
    input  wire [17:0] B,
    input  wire [2:0]  ALUctrl,
    output reg  [17:0] ALU_out,
    output wire        zero
);
    always @(*) begin
        case (ALUctrl)
            3'b000: ALU_out = A + B;                 // ADD
            3'b001: ALU_out = A - B;                 // SUB
            3'b010: ALU_out = ~(A & B);              // NAND
            3'b011: ALU_out = ~(A | B);              // NOR
            3'b100: ALU_out = A >> B[4:0];           // SRL
            3'b101: ALU_out = $signed(A) >>> B[4:0]; // SRA
            default: ALU_out = 18'b0;
        endcase
    end

    assign zero = (ALU_out == 18'b0);
endmodule
