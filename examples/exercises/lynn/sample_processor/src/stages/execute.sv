module execute(input logic clk, reset,
                input logic [31:0] ImmExtE,
                input logic [2:0] Funct3E,
                input logic [31:0] RD1E, RD2E,
                input logic [4:0] RdE,
                input logic [31:0] ResultW,
                input logic [31:0] PCE,
                input logic [31:0] InstrE,
                input logic IsAddE, IsBranchE, IsLoadE, IsStoreE, IsJumpE, IsShiftE, IsMulE, IsDivE, Unsigned_divE,


                input logic ALUResultSrcE, RegWriteE, MemWriteE,
                input logic  MemEnE, BranchE,
                input logic [1:0] ALUSrcE,
                input logic [2:0] ResultSrcE,
                input logic [3:0] ALUControlE,

                input logic [1:0] ForwardAE, ForwardBE,
                input logic [31:0] MemFwdData,
                input logic FlushM, StallM,
                output logic [2:0] Funct3M,
                output logic [4:0] RdM,

                output logic RegWriteM,
                output logic [2:0] ResultSrcM,
                output logic MemWriteM,
                output logic PCSrcE, MemEnM,
                output logic [31:0] InstrM,

                output logic [31:0] FSrcBM,
                output logic [31:0] IEUAdrE,
                output logic [31:0] ALUOutM,
                output logic [31:0] IEUAdrM,
                output logic [31:0] MulResultM, DivResultM, RemainM,
                output logic IsAddM, IsBranchM, IsLoadM, IsStoreM, IsJumpM, IsShiftM, IsMulM, BranchTakenM, div_busy, busy);

logic [31:0] FSrcAE, FSrcBE_int, ALUResultE, PCLinkE, AltResultE, SrcA, SrcB, Quotient, DivResultE;
logic [31:0] MStageFwd;
logic EqE, LTE, LTUE;
logic BranchTakenE;

assign MStageFwd = (ResultSrcM == 3'b001) ? MemFwdData
                   : (ResultSrcM == 3'b011) ? MulResultM
                   : ALUOutM;


always_comb begin
    case (ForwardAE)
        2'b00: FSrcAE = RD1E;
        2'b01: FSrcAE = ResultW;
        2'b10: FSrcAE = MStageFwd;
        default: FSrcAE = RD1E;
    endcase
end

always_comb begin
    case (ForwardBE)
        2'b00: FSrcBE_int = RD2E;
        2'b01: FSrcBE_int = ResultW;
        2'b10: FSrcBE_int = MStageFwd;
        default: FSrcBE_int = RD2E;
    endcase
end

cmp cmp(.R1(FSrcAE), .R2(FSrcBE_int), .Eq(EqE), .LT(LTE), .LTU(LTUE));

adder pcEadd4(.inputA(PCE), .inputB(32'd4), .result(PCLinkE));

mux2 #(32) srcamux(FSrcAE, PCE, ALUSrcE[1], SrcA);
mux2 #(32) srcbmux(FSrcBE_int, ImmExtE, ALUSrcE[0], SrcB);

alu alu(.SrcA(SrcA), .SrcB(SrcB), .ALUControl(ALUControlE), .ALUResult(ALUResultE), .IEUAdr(IEUAdrE));

logic [31:0] MulResultE;
logic [63:0] mul_ss, mul_su, mul_uu;

wire signed [63:0] ext_a_s = {{32{SrcA[31]}}, SrcA};
wire signed [63:0] ext_b_s = {{32{SrcB[31]}}, SrcB};
wire        [63:0] ext_b_u = {32'b0, SrcB};

assign mul_ss = ext_a_s * ext_b_s;
assign mul_su = ext_a_s * $signed(ext_b_u);
assign mul_uu = {32'b0, SrcA} * {32'b0, SrcB};

always_comb begin
    case (Funct3E[1:0])
        2'b00: MulResultE = mul_ss[31:0];
        2'b01: MulResultE = mul_ss[63:32];
        2'b10: MulResultE = mul_su[63:32];
        2'b11: MulResultE = mul_uu[63:32];
        default: MulResultE = 32'b0;
    endcase
end

logic [31:0] RemainE;

div div(.clk(clk), .reset(reset), .div(IsDivE), .is_unsigned(Unsigned_divE), .SrcA(SrcA), .SrcB(SrcB), .Quotient(DivResultE), .Remainder(RemainE), .busy(busy));

assign div_busy = busy;

logic ConditionMet;
always_comb begin
    case (Funct3E)
        3'b000: ConditionMet = EqE;
        3'b001: ConditionMet = ~EqE;
        3'b100: ConditionMet = LTE;
        3'b101: ConditionMet = ~LTE;
        3'b110: ConditionMet = LTUE;
        3'b111: ConditionMet = ~LTUE;
        default: ConditionMet = 1'b0;
    endcase
end
assign PCSrcE = (BranchE & ConditionMet) | IsJumpE;

assign BranchTakenE = BranchE & ConditionMet;
mux2 #(32) Pcplus(ImmExtE, PCLinkE, IsJumpE, AltResultE);

logic [31:0] ALUOutE;

assign ALUOutE = ALUResultSrcE ? AltResultE : ALUResultE;


logic [31:0] StoreDataE;

always_comb begin
    case (Funct3E)
        3'b000:  StoreDataE = {4{FSrcBE_int[7:0]}};
        3'b001:  StoreDataE = {2{FSrcBE_int[15:0]}};
        default: StoreDataE = FSrcBE_int;
    endcase
end

always_ff @(posedge clk) begin
    if (reset | FlushM) begin
        Funct3M <= 3'd0;
        RdM <= 5'd0;
        ResultSrcM <= 0;
        ALUOutM <= 32'd0;
        IEUAdrM <= 32'd0;
        FSrcBM <= 32'd0;
        MemWriteM <= 0;
        RegWriteM <= 0;
        MemEnM <= 0;
        InstrM <= 0;
        MulResultM <= 32'd0;
        DivResultM <= 32'd0;
        RemainM <= 32'd0;

        IsAddM <= 0;
        IsBranchM <= 0;
        IsLoadM <= 0;
        IsStoreM <= 0;
        IsJumpM <= 0;
        IsShiftM <= 0;
        IsMulM <= 0;
        BranchTakenM <= 0;

    end

    else if (!StallM) begin
        Funct3M <= Funct3E;
        RdM <= RdE;
        ResultSrcM <= ResultSrcE;
        ALUOutM <= ALUOutE;
        IEUAdrM <= IEUAdrE;
        FSrcBM <= StoreDataE;
        MemWriteM <= MemWriteE;
        RegWriteM <= RegWriteE;
        MemEnM <= MemEnE;
        InstrM <= InstrE;

        MulResultM <= MulResultE;
        DivResultM <= DivResultE;
        RemainM <= RemainE;


        IsAddM <= IsAddE;
        IsBranchM <= IsBranchE;
        IsLoadM <= IsLoadE;
        IsStoreM <= IsStoreE;
        IsJumpM <= IsJumpE;
        IsShiftM <= IsShiftE;
        IsMulM <= IsMulE;
        BranchTakenM <= BranchTakenE;
    end
end
endmodule
