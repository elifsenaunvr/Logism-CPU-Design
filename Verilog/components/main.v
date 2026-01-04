module main (
    input wire clk,
    input wire reset
);

    // Wires

    // PC
    wire [11:0] PC_out;
    wire [11:0] PC_offset;

    // Instruction
    wire [17:0] instr;
    wire [4:0]  opcode;

    // Register fields
    wire [3:0] rs1, rs2, rd;

    // Register file
    wire [17:0] regA, regB;
    wire [17:0] write_data;

    // Immediate
    wire [17:0] ExtImm;

    // ALU
    wire [17:0] alu_B;
    wire [17:0] ALU_out;
    wire        zero;

    // Data Memory
    wire [17:0] mem_data;

    // Control signals
    wire PCWrite, PCSrc;
    wire RegWrite;
    wire MemRead, MemWrite, MemToReg;
    wire ALUSrc;
    wire ExtSel;
    wire [2:0] ALUCtrl;

    // Instruction fields

    assign opcode = instr[17:13];
    assign rd  = instr[12:9];
    assign rs1 = instr[8:5];
    assign rs2 = instr[4:1];

    // Program Counter

    program_counter PC (
        .clk(clk),
        .reset(reset),
        .PC_Write(PCWrite),
        .PC_Src(PCSrc),
        .PC_offset(PC_offset),
        .PC_out(PC_out)
    );

    // Instruction Memory

    instruction_memory IM (
        .PC_Address(PC_out),
        .instr(instr)
    );

    // Register File

    register_file RF (
        .clk(clk),
        .reset(reset),
        .RegWrite(RegWrite),
        .write_addr(rd),
        .write_data(write_data),
        .rs1(rs1),
        .rs2(rs2),
        .rd1(regA),
        .rd2(regB)
    );

    // Extend Unit

    extend_unit EXT (
        .imm(instr[4:0]),
        .ExtSel(ExtSel),
        .ExtImm(ExtImm)
    );

    // ALU B MUX

    assign alu_B = (ALUSrc) ? ExtImm : regB;

    // ALU

    alu ALU (
        .A(regA),
        .B(alu_B),
        .ALUctrl(ALUCtrl),
        .ALU_out(ALU_out),
        .zero(zero)
    );

    // Data Memory

    data_memory DM (
        .clk(clk),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .Address(ALU_out[11:0]),
        .DataInput(regB),
        .DataOutput(mem_data)
    );

    // Write-back MUX

    assign write_data = (MemToReg) ? mem_data : ALU_out;

    // PC Offset Extension

    sign_extend_13_18 JEXT (
        .in(instr[12:0]),
        .extended_out({PC_offset})
    );

    // Control Unit

    control_unit CU (
        .clk(clk),
        .reset(reset),
        .opcode(opcode),

        .PCWrite(PCWrite),
        .PCSrc(PCSrc),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemToReg(MemToReg),
        .ALUSrc(ALUSrc),
        .ExtSel(ExtSel),
        .ALUCtrl(ALUCtrl),
        .state()
    );

endmodule
