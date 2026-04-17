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
logic MisPredE;
logic [31:0] PCCorE;
logic [31:0] PredPCNext;
logic [31:0] PredPCNextD;
logic [31:0] PredNextPCE;
logic [31:0] PCM;
logic [31:0] PCD, InstrD;

logic [31:0] IEUAdrE;

logic StallF, StallD, FlushD;


logic ALUResultSrcE, RegWriteE, MemWriteE;
logic [1:0] ResultSrcE;
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
logic [1:0] ResultSrcM;
logic [31:0] ALUOutM, InstrM, MulResultM;

logic [1:0] ForwardAE, ForwardBE;
logic StallM, FlushM;


logic RegWriteW;
logic [1:0] ResultSrcW;
logic [31:0] ALUOutW;
logic [4:0] RdW;

logic StallW, FlushW;

logic [31:0] ReadDataW, MulResultW;
logic [31:0] MemFwdData;

assign StallM = 0;
assign FlushM = 0;
assign StallW = 0;
assign FlushW = 0;

logic IsAddE, IsBranchE, IsLoadE, IsStoreE, IsJumpE, IsShiftE, IsMulE;
logic IsAddM, IsBranchM, IsLoadM, IsStoreM, IsJumpM, IsShiftM, IsMulM, BranchTakenM;
logic IsAddW, IsBranchW, IsLoadW, IsStoreW, IsJumpW, IsShiftW, IsMulW, BranchTakenW, MemWriteW;

branch_predict bp (
    .clk, .reset,
    .StallD, .FlushD,
    .StallM, .FlushM,
    .PCF(PC), .Instr,
    .PCM, .IsBranchM, .IsJumpM, .BranchTakenM, .IEUAdrM,
    .PredPCNext, .PredPCNextD);

fetch fetch(.clk, .reset, .Instr, .StallF, .StallD, .FlushD, .MisPredE, .PCCorE, .PredPCNext, .PCD, .PCF(PC), .InstrD);

decode decode(.clk, .reset, .InstrD, .PCD, .PredPCNextD, .StallD, .FlushE, .RdW, .RegWriteW, .ResultW, .InstrW, .ALUResultSrcE, .RegWriteE, .MemWriteE, .ResultSrcE,
   .ALUSrcE, .ALUControlE, .MemEnE, .BranchE, .PCE, .Funct3E, .RdE, .ImmExtE, .RD1D, .RD2D, .RD1E, .RD2E, .InstrE, .PredNextPCE, .IsAddE, .IsBranchE, .IsLoadE, .IsStoreE, .IsJumpE, .IsShiftE, .IsMulE);

execute execute(.clk, .reset, .StallM, .FlushM, .PredNextPCE, .ImmExtE, .Funct3E, .RD1E, .RD2E, .RdE, .ResultW, .InstrE, .IsAddE, .IsBranchE, .IsLoadE, .IsStoreE, .IsJumpE, .IsShiftE, .IsMulE, .PCE, .ALUResultSrcE, .RegWriteE, .MemWriteE,
    .PCSrcE, .ALUSrcE, .ResultSrcE, .ALUControlE, .MemEnE, .BranchE, .ForwardAE, .ForwardBE, .MemFwdData(MemFwdData), .Funct3M, .RdM, .PCM, .RegWriteM, .ResultSrcM,
    .MemWriteM, .MemEnM(MemEn), .FSrcBM(WriteData), .IEUAdrE(IEUAdrE), .ALUOutM, .InstrM, .IEUAdrM(IEUAdrM), .MulResultM, .IsAddM, .IsBranchM, .IsLoadM, .IsStoreM, .IsJumpM, .IsShiftM, .IsMulM, .BranchTakenM, .PCCorE, .MisPredE);

assign IEUAdr = IEUAdrM;

mem mem(.clk, .reset, .StallW, .FlushW, .RegWriteM, .MulResultM, .MemWriteM, .IsAddM, .IsBranchM, .IsLoadM, .IsStoreM, .IsJumpM, .IsShiftM, .IsMulM, .BranchTakenM, .MemEn, .ResultSrcM, .Funct3M, .IEUAdrM(IEUAdrM), .InstrM,
        .ReadData, .RdM, .WriteByteEn, .ALUOutM,  .RegWriteW, .ResultSrcW, .ALUOutW, .RdW, .ReadDataW, .MemFwdData(MemFwdData), .InstrW, .MulResultW, .IsAddW, .IsBranchW, .IsLoadW, .IsStoreW, .IsJumpW, .IsShiftW, .IsMulW, .BranchTakenW, .MemWriteW);

writeback write(.clk, .reset, .MulResultW, .ResultSrcW, .MemWriteW, .RegWriteW, .InstrW, .ALUOutW, .ReadDataW, .IsAddW, .IsBranchW, .IsLoadW, .IsStoreW, .IsJumpW, .IsShiftW, .IsMulW, .BranchTakenW, .ResultW);


hazard hazard(.Rs1E(InstrE[19:15]), .Rs2E(InstrE[24:20]), .RdM, .RdW, .RegWriteM, .RegWriteW, .Rs1D(InstrD[19:15]),
            .Rs2D(InstrD[24:20]), .RdE, .ResultSrcE, .MisPredE,
            .ForwardAE, .ForwardBE, .StallF, .StallD, .FlushE, .FlushD);

assign WriteEn = | WriteByteEn;

endmodule
