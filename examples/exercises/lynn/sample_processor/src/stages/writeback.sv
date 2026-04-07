module writeback(input logic clk, reset,
                input logic [31:0] MulResultW,
                input logic [1:0] ResultSrcW,
                input logic RegWriteW, MemWriteW,
                input logic [31:0] InstrW,
                input logic [31:0] ALUOutW, ReadDataW,
                input logic  IsAddW, IsBranchW, IsLoadW, IsStoreW, IsJumpW, IsShiftW, IsMulW, BranchTakenW,
                output logic [31:0] ResultW);

logic InstrRetired;
assign InstrRetired =  RegWriteW | MemWriteW | IsBranchW | IsJumpW;

logic [31:0] CSRDataW;

csr_unit csr (.clk(clk), .reset(reset), .InstrRetired(InstrRetired), .csr_addr(InstrW[31:20]), .is_add(IsAddW),
    .is_branch_eval(IsBranchW), .is_branch_taken(BranchTakenW), .is_load(IsLoadW), .is_store(IsStoreW), .is_jump(IsJumpW),
    .is_shift(IsShiftW), .is_mul(IsMulW), .csr_data(CSRDataW));

always_comb begin
    case(ResultSrcW)
        2'b00:   ResultW = ALUOutW;
        2'b01:   ResultW = ReadDataW;
        2'b10:   ResultW = CSRDataW;
        2'b11:   ResultW = MulResultW;
        default: ResultW = ALUOutW;
    endcase

end
endmodule
