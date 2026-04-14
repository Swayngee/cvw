// Branch prediction: compile-time selectable implementations.
// BPRED_TYPE: 0 = BTFNT (backward taken, forward not taken) + static JAL
//             1 = 2-bit bimodal PHT + direct-mapped BTB (tiny tables)
//
// PredPCNext  = next PC from fetch (PCF, Instr) — drives IF.
// PredPCNextD = PredPCNext pipelined with the decode stage (!StallD). Must be the
//               prediction made when this instruction was in fetch, not a fresh
//               PHT/BTB read (tables can change before execute — see Wally twoBitPredictor).

module branch_predict #(
    parameter int BPRED_TYPE = 0,
    parameter int INDEX_BITS = 6
) (
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

  localparam int DEPTH = 1 << INDEX_BITS;

  // ---------------- fetch path (PCF, Instr) ----------------
  logic [6:0] op;
  logic is_br, is_jal, is_jalr;
  logic [31:0] imm_b, imm_j;
  logic [31:0] pc_plus4;
  logic [31:0] tgt_br, tgt_jal;
  logic [INDEX_BITS-1:0] idx_f, idx_m;

  assign op = Instr[6:0];
  assign is_br = (op == 7'b1100011);
  assign is_jal = (op == 7'b1101111);
  assign is_jalr = (op == 7'b1100111);

  assign imm_b = {{20{Instr[31]}}, Instr[7], Instr[30:25], Instr[11:8], 1'b0};
  assign imm_j = {{12{Instr[31]}}, Instr[19:12], Instr[20], Instr[30:21], 1'b0};
  assign pc_plus4 = PCF + 32'd4;
  assign tgt_br = PCF + imm_b;
  assign tgt_jal = PCF + imm_j;

  assign idx_f = {PCF[INDEX_BITS+1] ^ PCF[1], PCF[INDEX_BITS:2]};
  assign idx_m = {PCM[INDEX_BITS+1] ^ PCM[1], PCM[INDEX_BITS:2]};

  // ---------------- 2-bit counters + BTB (BPRED_TYPE == 1) ----------------
  logic [1:0] pht[DEPTH];
  logic btb_v[DEPTH];
  logic [31:0] btb_tgt[DEPTH];

  logic [1:0] cnt_f;
  logic btb_hit_f;
  logic [31:0] btb_rd_f;
  logic dir_taken_f;
  logic pred_taken_bim;

  always_comb begin
    cnt_f = pht[idx_f];
    btb_hit_f = btb_v[idx_f];
    btb_rd_f = btb_tgt[idx_f];
    dir_taken_f = cnt_f[1];
    if (is_jal)
      pred_taken_bim = 1'b1;
    else if (is_jalr)
      pred_taken_bim = btb_hit_f;
    else if (is_br)
      pred_taken_bim = dir_taken_f;
    else
      pred_taken_bim = 1'b0;
  end

  logic [31:0] pred_tgt_bim;
  always_comb begin
    if (is_jal)
      pred_tgt_bim = tgt_jal;
    else if (is_jalr && btb_hit_f)
      pred_tgt_bim = {btb_rd_f[31:1], 1'b0};
    else if (is_br && dir_taken_f)
      pred_tgt_bim = {tgt_br[31:1], 1'b0};
    else
      pred_tgt_bim = pc_plus4;
  end

  function automatic logic [1:0] sat2_update(input logic taken, input logic [1:0] old_s);
    case (old_s)
      2'b00: sat2_update = taken ? 2'b01 : 2'b00;
      2'b01: sat2_update = taken ? 2'b10 : 2'b00;
      2'b10: sat2_update = taken ? 2'b11 : 2'b01;
      2'b11: sat2_update = taken ? 2'b11 : 2'b10;
      default: sat2_update = 2'b01;
    endcase
  endfunction

  integer ri;
  always_ff @(posedge clk) begin
    if (reset) begin
      for (ri = 0; ri < DEPTH; ri++) begin
        pht[ri] <= 2'b01;
        btb_v[ri] <= 1'b0;
        btb_tgt[ri] <= 32'b0;
      end
    end else if (!StallM && !FlushM) begin
      if (BPRED_TYPE == 1) begin
        if (IsBranchM) begin
          pht[idx_m] <= sat2_update(BranchTakenM, pht[idx_m]);
          if (BranchTakenM) begin
            btb_v[idx_m] <= 1'b1;
            btb_tgt[idx_m] <= {IEUAdrM[31:1], 1'b0};
          end
        end else if (IsJumpM) begin
          btb_v[idx_m] <= 1'b1;
          btb_tgt[idx_m] <= {IEUAdrM[31:1], 1'b0};
        end
      end
    end
  end

  // ---------------- BTFNT (BPRED_TYPE == 0) ----------------
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
    if (BPRED_TYPE == 0) begin
      if (pred_taken_btfnt && (is_br || is_jal))
        PredPCNext_comb = {pred_tgt_btfnt[31:1], 1'b0};
      else
        PredPCNext_comb = pc_plus4;
    end else begin
      if (pred_taken_bim && (is_br || is_jal || is_jalr))
        PredPCNext_comb = {pred_tgt_bim[31:1], 1'b0};
      else
        PredPCNext_comb = pc_plus4;
    end
  end

  assign PredPCNext = PredPCNext_comb;

  // Match fetch-time prediction; do not re-read PHT/BTB here (tables update in M).
  always_ff @(posedge clk) begin
    if (reset | FlushD)
      PredPCNextD <= 32'd0;
    else if (!StallD)
      PredPCNextD <= PredPCNext_comb;
  end

endmodule
