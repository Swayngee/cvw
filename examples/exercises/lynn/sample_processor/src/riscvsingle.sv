module riscvsingle (input   logic           clk,
        input   logic           reset,

        output  logic [31:0]    PC,  // instruction memory target address
        input   logic [31:0]    Instr, // instruction memory read data

        output  logic [31:0]    IEUAdr,  // data memory target address
        input   logic [31:0]    ReadData, // data memory read data
        output  logic [31:0]    WriteData, // data memory write data

        output  logic           MemEn,
        output  logic           WriteEn,
        output  logic [3:0]     WriteByteEn  // strobes, 1 hot stating weather a byte should be written on a store
    );

// fetch
logic PCSrcE;
logic [31:0] PCD, InstrD;

logic [31:0] IEUAdrE;

logic StallF, StallD, FlushD;

// decode
logic ALUResultSrcE, RegWriteE, MemWriteE, IsJumpE;
logic [1:0] ResultSrcE;
logic MemEnE, BranchE;
logic [1:0] ALUSrcE;
logic [3:0] ALUControlE;
logic [31:0] PCE, RD1D, RD2D, InstrE, ResultW;
logic [2:0] Funct3E;
logic [4:0] RdE;

logic FlushE;


// execute
logic [31:0] ImmExtE, IEUAdrM;
logic [31:0] RD1E, RD2E;
logic [2:0] Funct3M;
logic [4:0] RdM;
logic RegWriteM, MemWriteM, BranchTaken;
logic [1:0] ResultSrcM;
logic [31:0] ALUOutM;

logic [1:0] ForwardAE, ForwardBE;
logic StallM, FlushM;

// mem
logic RegWriteW;
logic [1:0] ResultSrcW;
logic [31:0] ALUOutW;
logic [4:0] RdW;

logic StallW, FlushW;

logic [31:0] ReadDataW;

// csr
logic [31:0] CSRDataE, CSRDataM, CSRDataW;

assign StallM = 0;
assign FlushM = 0;
assign StallW = 0;
assign FlushW = 0;

fetch fetch(.clk, .reset, .Instr, .StallF, .StallD, .FlushD, .PCSrc(PCSrcE), .IEUAdr(IEUAdrE), .PCD, .PCF(PC), .InstrD);

decode decode(.clk, .reset, .InstrD, .PCD, .FlushE, .RdW, .RegWriteW, .ResultW, .ALUResultSrcE, .RegWriteE, .MemWriteE, .BranchTaken, .ResultSrcE,
   .ALUSrcE, .ALUControlE, .MemEnE, .BranchE, .IsJumpE, .PCE, .Funct3E, .RdE, .ImmExtE, .RD1D, .RD2D, .RD1E, .RD2E, .InstrE, .CSRDataE);

execute execute(.clk, .reset, .StallM, .FlushM, .ImmExtE, .Funct3E, .RD1E, .RD2E, .RdE, .ResultW, .CSRDataE, .PCE, .ALUResultSrcE, .RegWriteE, .MemWriteE,
    .PCSrcE, .ALUSrcE, .ResultSrcE, .ALUControlE, .IsJumpE, .MemEnE, .BranchE, .ForwardAE, .ForwardBE, .Funct3M, .RdM, .RegWriteM, .BranchTaken, .ResultSrcM,
    .MemWriteM, .MemEnM(MemEn), .FSrcBM(WriteData), .IEUAdrE(IEUAdrE), .ALUOutM, .CSRDataM, .IEUAdrM(IEUAdrM));

assign IEUAdr = IEUAdrM;

mem mem(.clk, .reset, .StallW, .FlushW, .RegWriteM, .MemWriteM, .MemEn, .ResultSrcM, .Funct3M, .IEUAdrM(IEUAdrM),
        .ReadData, .RdM, .WriteByteEn, .ALUOutM, .CSRDataM, .RegWriteW, .ResultSrcW, .ALUOutW, .RdW, .CSRDataW, .ReadDataW);

writeback write(.ResultSrcW, .CSRDataW, .ALUOutW, .ReadDataW, .ResultW);

// pipeline hazard
hazard hazard(.Rs1E(InstrE[19:15]), .Rs2E(InstrE[24:20]), .RdM, .RdW, .RegWriteM, .RegWriteW, .Rs1D(InstrD[19:15]),
            .Rs2D(InstrD[24:20]), .RdE, .ResultSrcE0(ResultSrcE[0]), .PCSrcE,
            .ForwardAE, .ForwardBE, .StallF, .StallD, .FlushE, .FlushD);

assign WriteEn = | WriteByteEn;


//always_ff @(posedge clk) begin
//    $display("TOP: IEUAdr=%08x WriteEn=%b MemEn=%b WriteByteEn=%04b",
//        IEUAdr, WriteEn, MemEn, WriteByteEn);
//end

//always_ff @(posedge clk)
 //   $display("HAZ: Rs1E=%02d RdM=%02d RdW=%02d RegWriteM=%b RegWriteW=%b ForwardAE=%b",
 //       InstrE[19:15], RdM, RdW, RegWriteM, RegWriteW, ForwardAE);
endmodule
