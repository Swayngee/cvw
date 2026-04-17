module branch_predict (
    input logic clk,
    input logic reset,

    input logic StallD,
    input logic FlushD,

    input logic StallM,
    input logic FlushM,

    input logic [31:0] PCF,
    input logic [31:0] Instr,

    input logic [31:0] PCM,
    input logic IsBranchM,
    input logic IsJumpM,
    input logic BranchTakenM,
    input logic [31:0] IEUAdrM,

    output logic [31:0] PredPCNext,
    output logic [31:0] PredPCNextD
);

  logic [6:0] op;
  logic is_br, is_jal, is_jalr;
  logic [31:0] imm_b, imm_j;
  logic [31:0] pc_plus4;
  logic [31:0] tgt_br, tgt_jal;

  assign op = Instr[6:0];
  assign is_br = (op == 7'b1100011);
  assign is_jal = (op == 7'b1101111);
  assign is_jalr = (op == 7'b1100111);

  assign imm_b = {{20{Instr[31]}}, Instr[7], Instr[30:25], Instr[11:8], 1'b0};
  assign imm_j = {{12{Instr[31]}}, Instr[19:12], Instr[20], Instr[30:21], 1'b0};
  assign pc_plus4 = PCF + 32'd4;
  assign tgt_br = PCF + imm_b;
  assign tgt_jal = PCF + imm_j;

  logic pred_taken_btfnt;
  logic [31:0] pred_tgt_btfnt;
  always_comb begin
    if (is_jal) begin
      pred_taken_btfnt = 1'b1;
      pred_tgt_btfnt = tgt_jal;
    end else if (is_br) begin
      pred_taken_btfnt = imm_b[31];
      pred_tgt_btfnt = pred_taken_btfnt ? {tgt_br[31:1], 1'b0} : pc_plus4;
    end else begin
      pred_taken_btfnt = 1'b0;
      pred_tgt_btfnt = pc_plus4;
    end
  end

  logic [31:0] PredPCNext_comb;
  always_comb begin
    if (pred_taken_btfnt && (is_br || is_jal))
      PredPCNext_comb = {pred_tgt_btfnt[31:1], 1'b0};
    else
      PredPCNext_comb = pc_plus4;
  end

  assign PredPCNext = PredPCNext_comb;

  always_ff @(posedge clk) begin
    if (reset | FlushD)
      PredPCNextD <= 32'd0;
    else if (!StallD)
      PredPCNextD <= PredPCNext_comb;
  end

endmodule
