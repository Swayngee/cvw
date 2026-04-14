module writeback(input logic clk, reset,
                input logic [31:0] MulResultW, DivResultW, RemainW,
                input logic [2:0] ResultSrcW,
                input logic RegWriteW, MemWriteW,
                input logic [31:0] InstrW,
                input logic [31:0] ALUOutW, ReadDataW,
                input logic  IsAddW, IsBranchW, IsLoadW, IsStoreW, IsJumpW, IsShiftW, IsMulW, BranchTakenW,
                output logic [31:0] ResultW);

logic InstrRetired;
assign InstrRetired =  RegWriteW | MemWriteW | IsBranchW | IsJumpW;

//always_ff @(posedge clk) begin
 //   if (!reset && RegWriteW) begin
  //      $display("[TIME: %0t] WRITEBACK | InstrW: x%0d | Data: %h | ResultSrcW: %b",
  //               $time, InstrW, ResultW, ResultSrcW);
  //  end
//end

logic [31:0] CSRDataW;

csr_unit csr (.clk(clk), .reset(reset), .InstrRetired(InstrRetired), .csr_addr(InstrW[31:20]), .is_add(IsAddW),
    .is_branch_eval(IsBranchW), .is_branch_taken(BranchTakenW), .is_load(IsLoadW), .is_store(IsStoreW), .is_jump(IsJumpW),
    .is_shift(IsShiftW), .is_mul(IsMulW), .csr_data(CSRDataW));

always_comb begin
    case(ResultSrcW)
        3'b000:   ResultW = ALUOutW;
        3'b001:   ResultW = ReadDataW;
        3'b010:   ResultW = CSRDataW;
        3'b011:   ResultW = MulResultW;
        3'b100:   ResultW = DivResultW;
        3'b101:   ResultW = RemainW;
        default: ResultW = ALUOutW;
    endcase

end
endmodule
