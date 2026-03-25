`include "parameters.svh"
module controller(
    input  logic [6:0] Op,
    input  logic [2:0] Funct3,
    input  logic       Funct7b5,
    input  logic       Funct7b0,
    output logic       ALUResultSrc,
    output logic [1:0] ResultSrc,
    output logic       MemWrite,
    output logic       RegWrite,
    output logic [1:0] ALUSrc,
    output logic [2:0] ImmSrc,
    output logic [3:0] ALUControl,
    output logic       MemEn,
    output logic       Branch, IsAdd, IsBranch,  IsLoad, IsStore, IsJump, IsShift
);

    logic Jump;
    logic [1:0] ALUOp;

    always_comb begin
        // SAFE DEFAULTS: Clamps all signals to 0 to prevent ANY glitches or X-propagation
        RegWrite = 0; ImmSrc = 3'b000; ALUSrc = 2'b00; ALUOp = 2'b00;
        ALUResultSrc = 0; MemWrite = 0; ResultSrc = 2'b00;
        Branch = 0; Jump = 0; MemEn = 0;

        case(Op)
            7'b0000011: begin // LW
                RegWrite = 1; ImmSrc = 3'b000; ALUSrc = 2'b01; ALUOp = 2'b00; MemEn = 1; ResultSrc = 2'b01;
            end
            7'b0100011: begin // SW
                ImmSrc = 3'b001; ALUSrc = 2'b01; ALUOp = 2'b00; MemWrite = 1; MemEn = 1;
            end
            7'b0110011: begin // R-type / Zmmul
                RegWrite = 1; ALUSrc = 2'b00; ALUOp = 2'b10;
                if (Funct7b0) ResultSrc = 2'b11; // Zmmul
                else          ResultSrc = 2'b00; // R-type
            end
            7'b0010011: begin // I-type
                RegWrite = 1; ImmSrc = 3'b000; ALUSrc = 2'b01; ALUOp = 2'b10;
            end
            7'b1100011: begin // Branch
                ImmSrc = 3'b010; ALUSrc = 2'b11; ALUOp = 2'b00; Branch = 1;
            end
            7'b1101111: begin // JAL
                RegWrite = 1; ImmSrc = 3'b011; ALUSrc = 2'b11; ALUOp = 2'b00; ALUResultSrc = 1; Jump = 1;
            end
            7'b1100111: begin // JALR
                RegWrite = 1; ImmSrc = 3'b000; ALUSrc = 2'b01; ALUOp = 2'b00; ALUResultSrc = 1; Jump = 1;
            end
            7'b0110111: begin // LUI
                RegWrite = 1; ImmSrc = 3'b100; ALUSrc = 2'b01; ALUOp = 2'b00; ALUResultSrc = 1;
            end
            7'b0010111: begin // AUIPC
                RegWrite = 1; ImmSrc = 3'b100; ALUSrc = 2'b11; ALUOp = 2'b00;
            end
            7'b1110011: begin // SYSTEM (CSR)
                RegWrite = 1; ResultSrc = 2'b10;
            end
            default: begin end // Keeps safe defaults
        endcase
    end

    // ALU Control logic
    always_comb begin
        if      (ALUOp == 2'b00) ALUControl = 4'b0000;
        else if (ALUOp == 2'b01) ALUControl = 4'b0001;
        else begin
            case (Funct3)
                3'b000: ALUControl = (Op[5] & Funct7b5) ? 4'b0001 : 4'b0000;
                3'b001: ALUControl = 4'b0111;
                3'b010: ALUControl = 4'b0101;
                3'b011: ALUControl = 4'b0110;
                3'b100: ALUControl = 4'b0100;
                3'b101: ALUControl = Funct7b5 ? 4'b1001 : 4'b1000;
                3'b110: ALUControl = 4'b0011;
                3'b111: ALUControl = 4'b0010;
                default: ALUControl = 4'b0000;
            endcase
        end
    end

    assign IsAdd       = ((Op == 7'b0110011) & (Funct3 == 3'b000) & ~Funct7b5 & ~Funct7b0) | ((Op == 7'b0010011) & (Funct3 == 3'b000));
    assign IsBranch    = Branch;
    assign IsLoad      = (Op == 7'b0000011);
    assign IsStore     = (Op == 7'b0100011);
    assign IsJump      = Jump;
    assign IsShift     = ((Op == 7'b0110011) | (Op == 7'b0010011)) & ((Funct3 == 3'b001) | (Funct3 == 3'b101));
endmodule
