// Arithmetic Logic Unit (ALU)
// Supports arithmetic and logical operations for the processor
module alu (
    input  wire [17:0] A,        // First operand (from register file)
    input  wire [17:0] B,        // Second operand (register or immediate)
    input  wire [2:0]  ALUctrl,  // ALU control signal (selects operation)
    output reg  [17:0] ALU_out,  // ALU result
    output wire        zero      // Zero flag (used for CMOV)
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

// Zero flag is set when ALU result is zero
assign zero = (ALU_out == 18'b0);

endmodule
