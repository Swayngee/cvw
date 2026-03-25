// riscvsingle.sv
// RISC-V single-cycle processor
// David_Harris@hmc.edu 2020

module extend(
        input   logic [31:7]    Instr,
        input   logic [2:0]     ImmSrc,
        output  logic [31:0]    ImmExt
    );

always_comb
    case(ImmSrc)
        3'b000: ImmExt = {{20{Instr[31]}}, Instr[31:20]};              // I-type
        3'b001: ImmExt = {{20{Instr[31]}}, Instr[31:25], Instr[11:7]}; // S-type
        3'b010: ImmExt = {{20{Instr[31]}}, Instr[7], Instr[30:25], Instr[11:8], 1'b0}; // B-type
        3'b011: ImmExt = {{12{Instr[31]}},   // sign extend [31:20]
                   Instr[19:12],       // imm[19:12]
                   Instr[20],          // imm[11]
                   Instr[30:21],       // imm[10:1]
                   1'b0};              // imm[0] always 0
        3'b100: ImmExt = {Instr[31:12], 12'b0};                        // U-type (LUI/AUIPC)
        default: ImmExt = 32'bx;
    endcase

endmodule
