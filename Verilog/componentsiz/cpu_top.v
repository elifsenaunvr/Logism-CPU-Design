// Top-level CPU Module
// Integrates all components: PC, Instruction Memory, Control Unit,
// Register File, ALU, Data Memory, and Extend Unit
module cpu_top (
    input wire clk,
    input wire reset
);

    // Program Counter (PC)
    reg [11:0] PC;
    wire [11:0] PC_next;
    wire [11:0] PC_plus1;
    wire [11:0] PC_branch;

    assign PC_plus1  = PC + 12'd1;
    assign PC_branch = PC_plus1 + instr[12:1]; // PC-relative

    always @(posedge clk or posedge reset) begin
        if (reset)
            PC <= 12'd0;
        else if (PCWrite)
            PC <= PC_next;
    end

    assign PC_next = (PCSrc) ? PC_branch : PC_plus1;

    // Instruction Memory
    wire [17:0] instr;

    inst_memory IM (
        .addr(PC),
        .data(instr)
    );

    // Instruction fields
    wire [4:0] opcode = instr[17:13];
    wire [3:0] rd     = instr[12:9];
    wire [3:0] rs1    = instr[8:5];
    wire [3:0] rs2    = instr[4:1];
    wire [4:0] imm5   = instr[4:0];

    // Control Unit
    wire RegWrite, ALUSrc, MemRead, MemWrite;
    wire MemToReg, PCWrite, PCSrc, ExtSel;
    wire [2:0] ALUCtrl;

    control_unit CU (
        .clk(clk),
        .reset(reset),
        .opcode(opcode),
        .RegWrite(RegWrite),
        .ALUSrc(ALUSrc),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemToReg(MemToReg),
        .PCWrite(PCWrite),
        .PCSrc(PCSrc),
        .ExtSel(ExtSel),
        .ALUCtrl(ALUCtrl)
    );

    // Register File
    wire [17:0] regA, regB, writeBackData;

    register_file RF (
        .clk(clk),
        .reset(reset),
        .regWrite(RegWrite),
        .writeReg(rd),
        .writeData(writeBackData),
        .readReg1(rs1),
        .readReg2(rs2),
        .readData1(regA),
        .readData2(regB)
    );

    // Extend Unit
    wire [17:0] ExtImm;

    extend_unit EU (
        .imm(imm5),
        .ExtSel(ExtSel),
        .ExtImm(ExtImm)
    );

    // ALU
    wire [17:0] ALU_in2;
    wire [17:0] ALU_out;

    assign ALU_in2 = (ALUSrc) ? ExtImm : regB;

    alu ALU (
        .A(regA),
        .B(ALU_in2),
        .ALUctrl(ALUCtrl),
        .ALU_out(ALU_out),
        .zero()
    );

    // Data Memory
    wire [17:0] MemData;

    data_memory DM (
        .clk(clk),
        .addr(ALU_out[11:0]),
        .writeData(regB),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .readData(MemData)
    );

    // Write-back MUX
    assign writeBackData = (MemToReg) ? MemData : ALU_out;

endmodule
