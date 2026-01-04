// Control Unit Module
// Implements a finite state machine (FSM) to control the datapath
module control_unit (
    input  wire        clk,
    input  wire        reset,
    input  wire [4:0]  opcode,

    output reg         RegWrite,
    output reg         ALUSrc,
    output reg         MemRead,
    output reg         MemWrite,
    output reg         MemToReg,
    output reg         PCWrite,
    output reg         PCSrc,
    output reg         ExtSel,
    output reg  [2:0]  ALUCtrl
);

    // FSM state register
    reg [3:0] state, next_state;

    // State encoding
    localparam FETCH        = 4'b0000,
               DECODE       = 4'b0001,
               EXECUTE      = 4'b0010,
               WB_RTYPE     = 4'b0011,
               MEM_READ     = 4'b0100,
               WB_LD        = 4'b0101,
               MEM_WRITE    = 4'b0110,
               STACK_WRITE  = 4'b0111,
               STACK_DEC    = 4'b1000,
               STACK_READ   = 4'b1001,
               POP_WRITE    = 4'b1010,
               STACK_INC    = 4'b1011,
               JUMP_JAL     = 4'b1100;

    // State register
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= FETCH;
        else
            state <= next_state;
    end

    // Default outputs
    always @(*) begin
        // defaults
        RegWrite  = 0;
        ALUSrc   = 0;
        MemRead  = 0;
        MemWrite = 0;
        MemToReg = 0;
        PCWrite  = 0;
        PCSrc    = 0;
        ExtSel   = 0;
        ALUCtrl  = 3'b000;

        next_state = FETCH;

        case (state)

            FETCH: begin
                PCWrite   = 1;
                ALUCtrl   = 3'b000; // ADD
                next_state = DECODE;
            end

            DECODE: begin
                case (opcode)
                    5'b01010, // JUMP
                    5'b01011: // JAL
                        next_state = JUMP_JAL;

                    5'b01100: next_state = MEM_READ;  // LD
                    5'b01101: next_state = MEM_WRITE; // ST

                    5'b01110: next_state = STACK_WRITE; // PUSH
                    5'b01111: next_state = STACK_READ;  // POP

                    default:  next_state = EXECUTE; // R / I type
                endcase
            end

            EXECUTE: begin
                ALUSrc = (opcode[4:2] == 3'b001); // I-type
                ALUCtrl = opcode[2:0];
                next_state = WB_RTYPE;
            end

            WB_RTYPE: begin
                RegWrite = 1;
                next_state = FETCH;
            end

            MEM_READ: begin
                MemRead = 1;
                next_state = WB_LD;
            end

            WB_LD: begin
                RegWrite = 1;
                MemToReg = 1;
                next_state = FETCH;
            end

            MEM_WRITE: begin
                MemWrite = 1;
                next_state = FETCH;
            end

            JUMP_JAL: begin
                PCWrite = 1;
                PCSrc   = 1;
                if (opcode == 5'b01011) // JAL
                    RegWrite = 1;
                next_state = FETCH;
            end

            default: next_state = FETCH;

        endcase
    end

endmodule
