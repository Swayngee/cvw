module execute(input logic clk, reset,
                
                input logic [31:0] ImmExtE,
                input logic [2:0] Funct3E,
                input logic [31:0] RD1E, RD2E,
                input logic [4:0] RdE,
                input logic [31:0] ResultW,
                input logic [31:0] CSRDataE,
                input logic [31:0] PCE,

                
                input logic ALUResultSrcE, RegWriteE, MemWriteE,
                input logic  MemEnE, BranchE,
                input logic [1:0] ALUSrcE, ResultSrcE,
                input logic [3:0] ALUControlE,
                input logic IsJumpE,
                
                input logic [1:0] ForwardAE, ForwardBE,
                input logic [31:0] MemFwdData,
                input logic FlushM, StallM,
                output logic [2:0] Funct3M,
                output logic [4:0] RdM,
                
                output logic RegWriteM, BranchTaken,
                output logic [1:0] ResultSrcM,
                output logic MemWriteM,
                output logic PCSrcE, MemEnM,
                
                output logic [31:0] FSrcBM,
                output logic [31:0] IEUAdrE,
                output logic [31:0] ALUOutM,
                output logic [31:0] CSRDataM,
                output logic [31:0] IEUAdrM);

logic [31:0] FSrcAE, FSrcBE_int, ALUResultE, PCLinkE, AltResultE, SrcA, SrcB;
logic [31:0] MStageFwd;
logic EqE, LTE, LTUE;


assign MStageFwd = (ResultSrcM == 2'b01) ? MemFwdData : ALUOutM;


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

assign BranchTaken = BranchE & ConditionMet;
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
        CSRDataM <= 32'd0;
        IEUAdrM <= 32'd0;
        FSrcBM <= 32'd0;
        MemWriteM <= 0;
        RegWriteM <= 0;
        MemEnM <= 0;
    end

    else if (!StallM) begin
        Funct3M <= Funct3E;
        RdM <= RdE;
        ResultSrcM <= ResultSrcE;
        ALUOutM <= ALUOutE;
        CSRDataM <= CSRDataE;
        IEUAdrM <= IEUAdrE;
        FSrcBM <= StoreDataE;
        MemWriteM <= MemWriteE;
        RegWriteM <= RegWriteE;
        MemEnM <= MemEnE;
    end
end



    
        
            



endmodule
