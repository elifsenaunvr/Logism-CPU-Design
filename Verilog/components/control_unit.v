module control_unit (
    input  wire        clk,
    input  wire        reset,
    input  wire [4:0]  opcode,

    output reg         PCWrite,
    output reg         PCSrc,
    output reg         RegWrite,
    output reg         MemRead,
    output reg         MemWrite,
    output reg         MemToReg,
    output reg         ALUSrc,
    output reg         ExtSel,
    output reg  [2:0]  ALUCtrl,
    output reg  [3:0]  state
);

    localparam S0_FETCH      = 4'b0000;
    localparam S1_DECODE     = 4'b0001;
    localparam S2_EXECUTE    = 4'b0010;
    localparam S3_WB_RI      = 4'b0011;
    localparam S4_MEM_READ   = 4'b0100;
    localparam S5_WB_LD      = 4'b0101;
    localparam S6_MEM_WRITE  = 4'b0110;
    localparam S7_STACK_WR   = 4'b0111;
    localparam S8_STACK_DEC  = 4'b1000;
    localparam S9_STACK_RD   = 4'b1001;
    localparam S10_POP_WB    = 4'b1010;
    localparam S11_STACK_INC = 4'b1011;
    localparam S12_JUMP_JAL  = 4'b1100;

    localparam OP_ADD   = 5'b00000;
    localparam OP_SUB   = 5'b00001;
    localparam OP_NAND  = 5'b00010;
    localparam OP_NOR   = 5'b00011;
    localparam OP_SRL   = 5'b00100;
    localparam OP_SRA   = 5'b00101;
    localparam OP_ADDI  = 5'b00110;
    localparam OP_SUBI  = 5'b00111;
    localparam OP_NANDI = 5'b01000;
    localparam OP_NORI  = 5'b01001;
    localparam OP_JUMP  = 5'b01010;
    localparam OP_JAL   = 5'b01011;
    localparam OP_LD    = 5'b01100;
    localparam OP_ST    = 5'b01101;
    localparam OP_PUSH  = 5'b01110;
    localparam OP_POP   = 5'b01111;
    localparam OP_LUI   = 5'b10000;
    localparam OP_CMOV  = 5'b10001;

    reg [3:0] next_state;

    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= S0_FETCH;
        else
            state <= next_state;
    end

    always @(*) begin
        next_state = state;
        case (state)
            S0_FETCH:       next_state = S1_DECODE;
            S1_DECODE: begin
                if (opcode == OP_JUMP || opcode == OP_JAL)
                    next_state = S12_JUMP_JAL;
                else if (opcode == OP_LD)
                    next_state = S4_MEM_READ;
                else if (opcode == OP_ST)
                    next_state = S6_MEM_WRITE;
                else if (opcode == OP_PUSH)
                    next_state = S7_STACK_WR;
                else if (opcode == OP_POP)
                    next_state = S9_STACK_RD;
                else
                    next_state = S2_EXECUTE;
            end
            S2_EXECUTE:     next_state = S3_WB_RI;
            S3_WB_RI:       next_state = S0_FETCH;
            S4_MEM_READ:    next_state = S5_WB_LD;
            S5_WB_LD:       next_state = S0_FETCH;
            S6_MEM_WRITE:   next_state = S0_FETCH;
            S7_STACK_WR:    next_state = S8_STACK_DEC;
            S8_STACK_DEC:   next_state = S0_FETCH;
            S9_STACK_RD:    next_state = S10_POP_WB;
            S10_POP_WB:     next_state = S11_STACK_INC;
            S11_STACK_INC:  next_state = S0_FETCH;
            S12_JUMP_JAL:   next_state = S0_FETCH;
            default:        next_state = S0_FETCH;
        endcase
    end

    always @(*) begin
        PCWrite  = 1'b0;
        PCSrc    = 1'b0;
        RegWrite = 1'b0;
        MemRead  = 1'b0;
        MemWrite = 1'b0;
        MemToReg = 1'b0;
        ALUSrc   = 1'b0;
        ExtSel   = 1'b0;
        ALUCtrl  = 3'b000;

        case (state)
            S0_FETCH: begin
                PCWrite = 1'b1;
                PCSrc   = 1'b0;
                ALUCtrl = 3'b000;
            end

            S2_EXECUTE: begin
                case (opcode)
                    OP_ADD:   ALUCtrl = 3'b000;
                    OP_SUB:   ALUCtrl = 3'b001;
                    OP_NAND:  ALUCtrl = 3'b010;
                    OP_NOR:   ALUCtrl = 3'b011;
                    OP_SRL:   ALUCtrl = 3'b100;
                    OP_SRA:   ALUCtrl = 3'b101;
                    OP_ADDI:  begin ALUCtrl = 3'b000; ALUSrc = 1'b1; ExtSel = 1'b0; end
                    OP_SUBI:  begin ALUCtrl = 3'b001; ALUSrc = 1'b1; ExtSel = 1'b0; end
                    OP_NANDI: begin ALUCtrl = 3'b010; ALUSrc = 1'b1; ExtSel = 1'b0; end
                    OP_NORI:  begin ALUCtrl = 3'b011; ALUSrc = 1'b1; ExtSel = 1'b0; end
                    default:  ALUCtrl = 3'b000;
                endcase
            end

            S3_WB_RI: begin
                RegWrite = 1'b1;
                MemToReg = 1'b0;
            end

            S4_MEM_READ: begin
                MemRead = 1'b1;
            end

            S5_WB_LD: begin
                RegWrite = 1'b1;
                MemToReg = 1'b1;
            end

            S6_MEM_WRITE: begin
                MemWrite = 1'b1;
            end

            S7_STACK_WR: begin
                MemWrite = 1'b1;
            end

            S8_STACK_DEC: begin
                RegWrite = 1'b1;
                ALUSrc   = 1'b1;
                ALUCtrl  = 3'b001;
            end

            S9_STACK_RD: begin
                MemRead = 1'b1;
            end

            S10_POP_WB: begin
                RegWrite = 1'b1;
                MemToReg = 1'b1;
            end

            S11_STACK_INC: begin
                RegWrite = 1'b1;
                ALUSrc   = 1'b1;
                ALUCtrl  = 3'b000;
            end

            S12_JUMP_JAL: begin
                PCWrite = 1'b1;
                PCSrc   = 1'b1;
                if (opcode == OP_JAL)
                    RegWrite = 1'b1;
            end
        endcase
    end

endmodule
