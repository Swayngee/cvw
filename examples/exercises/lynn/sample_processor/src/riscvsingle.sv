module riscvsingle (input   logic           clk,
        input   logic           reset,

        output  logic [31:0]    PC,
        input   logic [31:0]    Instr,

        output  logic [31:0]    IEUAdr,
        input   logic [31:0]    ReadData,
        output  logic [31:0]    WriteData,

        output  logic           MemEn,
        output  logic           WriteEn,
        output  logic [3:0]     WriteByteEn);


logic PCSrcE;
logic [31:0] PCD, InstrD;

logic [31:0] IEUAdrE;

logic StallF, StallD, FlushD;


logic ALUResultSrcE, RegWriteE, MemWriteE;
logic [2:0] ResultSrcE;
logic MemEnE, BranchE;
logic [1:0] ALUSrcE;
logic [3:0] ALUControlE;
logic [31:0] PCE, RD1D, RD2D, InstrE, InstrW, ResultW;
logic [2:0] Funct3E;
logic [4:0] RdE;

logic FlushE;



logic [31:0] ImmExtE, IEUAdrM;
logic [31:0] RD1E, RD2E;
logic [2:0] Funct3M;
logic [4:0] RdM;
logic RegWriteM, MemWriteM;
logic [2:0] ResultSrcM;
logic [31:0] ALUOutM, InstrM, MulResultM, RemainM, RemainW;

logic [1:0] ForwardAE, ForwardBE;
logic StallM, FlushM;


logic RegWriteW;
logic [2:0] ResultSrcW;
logic [31:0] ALUOutW;
logic [4:0] RdW;

logic StallW, FlushW, div_busy, busy;

logic [31:0] ReadDataW, MulResultW;
logic [31:0] MemFwdData;

assign StallM = 0;
assign StallW = 0;
assign FlushW = 0;

logic [31:0] DivResultM, DivResultW;
logic IsAddE, IsBranchE, IsLoadE, IsStoreE, IsJumpE, IsShiftE, IsMulE, IsDivE, Unsigned_divE;
logic IsAddM, IsBranchM, IsLoadM, IsStoreM, IsJumpM, IsShiftM, IsMulM, BranchTakenM;
logic IsAddW, IsBranchW, IsLoadW, IsStoreW, IsJumpW, IsShiftW, IsMulW, BranchTakenW, MemWriteW;

fetch fetch(.clk(clk), .reset(reset), .Instr(Instr), .StallF(StallF), .StallD(StallD), .FlushD(FlushD), .PCSrc(PCSrcE), .IEUAdr(IEUAdrE), .PCD(PCD), .PCF(PC), .InstrD(InstrD));

decode decode(.clk(clk), .reset(reset), .InstrD(InstrD), .PCD(PCD), .StallD(StallD), .FlushE(FlushE), .ResultW(ResultW), .RdW(RdW), .RegWriteW(RegWriteW),  .ALUResultSrcE(ALUResultSrcE), .RegWriteE(RegWriteE), .MemWriteE(MemWriteE), .ResultSrcE(ResultSrcE),
        .ALUSrcE(ALUSrcE), .ALUControlE(ALUControlE), .MemEnE(MemEnE), .BranchE(BranchE), .PCE(PCE), .Funct3E(Funct3E), .RdE(RdE), .ImmExtE(ImmExtE), .RD1D(RD1D), .RD2D(RD2D), .RD1E(RD1E), .RD2E(RD2E), .InstrE(InstrE), .IsAddE(IsAddE), .IsBranchE(IsBranchE), .IsLoadE(IsLoadE), .IsStoreE(IsStoreE), .IsJumpE(IsJumpE), .IsShiftE(IsShiftE), .IsMulE(IsMulE), .IsDivE(IsDivE), .Unsigned_divE(Unsigned_divE));

execute execute(.clk(clk), .reset(reset), .ImmExtE(ImmExtE), .Funct3E(Funct3E), .RD1E(RD1E), .RD2E(RD2E), .RdE(RdE), .ResultW(ResultW), .PCE(PCE), .InstrE(InstrE), .IsAddE(IsAddE), .IsBranchE(IsBranchE), .IsLoadE(IsLoadE), .IsStoreE(IsStoreE), .IsJumpE(IsJumpE), .IsShiftE(IsShiftE), .IsMulE(IsMulE), .IsDivE(IsDivE), .Unsigned_divE(Unsigned_divE), .ALUResultSrcE(ALUResultSrcE), .RegWriteE(RegWriteE), .MemWriteE(MemWriteE),
         .PCSrcE(PCSrcE), .ALUSrcE(ALUSrcE), .ResultSrcE(ResultSrcE), .ALUControlE(ALUControlE), .MemEnE(MemEnE), .BranchE(BranchE), .ForwardAE(ForwardAE), .ForwardBE(ForwardBE), .MemFwdData(MemFwdData), .Funct3M(Funct3M), .RdM(RdM), .RegWriteM(RegWriteM), .ResultSrcM(ResultSrcM),
         .MemWriteM(MemWriteM), .MemEnM(MemEn), .FSrcBM(WriteData), .IEUAdrE(IEUAdrE), .ALUOutM(ALUOutM), .InstrM(InstrM), .IEUAdrM(IEUAdrM), .MulResultM(MulResultM), .DivResultM(DivResultM), .RemainM(RemainM), .div_busy(div_busy), .IsAddM(IsAddM), .IsBranchM(IsBranchM), .IsLoadM(IsLoadM), .IsStoreM(IsStoreM), .IsJumpM(IsJumpM), .IsShiftM(IsShiftM), .IsMulM(IsMulM), .BranchTakenM(BranchTakenM), .busy(busy), .StallM(StallM), .FlushM(FlushM));

assign IEUAdr = IEUAdrM;


mem mem(.clk(clk), .reset(reset), .StallW(StallW), .FlushW(FlushW), .RegWriteM(RegWriteM), .MulResultM(MulResultM), .DivResultM(DivResultM), .RemainM(RemainM), .MemWriteM(MemWriteM), .IsAddM(IsAddM), .IsBranchM(IsBranchM), .IsLoadM(IsLoadM), .IsStoreM(IsStoreM), .IsJumpM(IsJumpM), .IsShiftM(IsShiftM), .IsMulM(IsMulM), .BranchTakenM(BranchTakenM), .MemEn(MemEn), .ResultSrcM(ResultSrcM), .Funct3M(Funct3M), .IEUAdrM(IEUAdrM), .InstrM(InstrM),
        .ReadData(ReadData), .RdM(RdM), .WriteByteEn(WriteByteEn), .ALUOutM(ALUOutM),  .RegWriteW(RegWriteW), .ResultSrcW(ResultSrcW), .ALUOutW(ALUOutW), .RdW(RdW), .ReadDataW(ReadDataW), .MemFwdData(MemFwdData), .InstrW(InstrW), .MulResultW(MulResultW), .DivResultW(DivResultW), .RemainW(RemainW), .IsAddW(IsAddW), .IsBranchW(IsBranchW), .IsLoadW(IsLoadW), .IsStoreW(IsStoreW), .IsJumpW(IsJumpW), .IsShiftW(IsShiftW), .IsMulW(IsMulW), .BranchTakenW(BranchTakenW), .MemWriteW(MemWriteW));

writeback write(.clk(clk), .reset(reset), .MulResultW(MulResultW), .DivResultW(DivResultW), .RemainW(RemainW), .ResultSrcW(ResultSrcW), .MemWriteW(MemWriteW), .RegWriteW(RegWriteW), .InstrW(InstrW), .ALUOutW(ALUOutW), .ReadDataW(ReadDataW), .IsAddW(IsAddW), .IsBranchW(IsBranchW), .IsLoadW(IsLoadW), .IsStoreW(IsStoreW), .IsJumpW(IsJumpW), .IsShiftW(IsShiftW), .IsMulW(IsMulW), .BranchTakenW(BranchTakenW), .ResultW(ResultW));


hazard hazard(.Rs1E(InstrE[19:15]), .Rs2E(InstrE[24:20]), .RdM(RdM), .RdW(RdW), .RegWriteM(RegWriteM), .RegWriteW(RegWriteW), .Rs1D(InstrD[19:15]),
            .Rs2D(InstrD[24:20]), .RdE(RdE), .ResultSrcE(ResultSrcE), .PCSrcE(PCSrcE),  .IsMulE(IsMulE), .IsDivE(IsDivE), .busy(busy), .div_busy(div_busy),
            .ForwardAE(ForwardAE), .ForwardBE(ForwardBE), .StallF(StallF), .StallD(StallD), .FlushE(FlushE), .FlushD(FlushD), .FlushM(FlushM));

assign WriteEn = | WriteByteEn;

endmodule
