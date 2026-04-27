module mul(input  logic clk,
            input  logic reset,
            input  logic StallM,
            input  logic FlushM,
            input  logic [31:0] SrcA, SrcB,
            input  logic [2:0]  Funct3E,
            output logic [31:0] MulResultM);

    logic signed [32:0] mul_a, mul_b;

    logic signed [32:0] mul_a_reg, mul_b_reg;
    logic [2:0] Funct3_reg;
    logic signed [65:0] mul_full;
    always_comb begin
        if (Funct3E == 3'b011) mul_a = {1'b0, SrcA};
        else mul_a = {SrcA[31], SrcA};

        if (Funct3E[1]) mul_b = {1'b0, SrcB};
        else mul_b = {SrcB[31], SrcB};
    end

    always_ff @(posedge clk) begin
        if (reset | FlushM) begin
            mul_a_reg  <= 33'd0;
            mul_b_reg  <= 33'd0;
            Funct3_reg <= 3'd0;
        end else if (!StallM) begin
            mul_a_reg  <= mul_a;
            mul_b_reg  <= mul_b;
            Funct3_reg <= Funct3E;
        end
    end

    assign mul_full = mul_a_reg * mul_b_reg;

    always_comb begin
        case (Funct3_reg[1:0])
            2'b00:   MulResultM = mul_full[31:0];   // MUL
            default: MulResultM = mul_full[63:32];  // MULH, MULHSU, MULHU
        endcase
    end

endmodule
