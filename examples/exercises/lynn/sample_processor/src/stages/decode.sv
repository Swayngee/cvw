
module decode(input clk, reset,
    input  logic [31:0] InstrD, PCD,
    input logic StallD,
    input logic FlushE,
    input logic [31:0] ResultW,
    input logic [4:0] RdW,
    input logic RegWriteW,
    output logic  ALUResultSrcE, RegWriteE, MemWriteE,
    output logic [2:0] ResultSrcE,
    output logic MemEnE, BranchE,
    output logic [1:0] ALUSrcE,
    output logic [3:0] ALUControlE,

    output logic [31:0] PCE,
    output logic [2:0] Funct3E,
    output logic [4:0] RdE,
    output logic [31:0] ImmExtE,
    output logic [31:0] RD1D, RD2D,
    output logic [31:0] RD1E, RD2E,
    output logic [31:0] InstrE,
    output logic IsAddE, IsBranchE, IsLoadE, IsStoreE, IsJumpE, IsShiftE, IsMulE, IsDivE, Unsigned_divE);

logic ALUResultSrcD, RegWriteD, MemWriteD;
logic [2:0] ResultSrcD;
logic MemEnD, BranchD;
logic [1:0] ALUSrcD;
logic [2:0] ImmSrcD;
logic [3:0] ALUControlD;

logic IsAddD, IsBranchD, IsLoadD, IsStoreD, IsJumpD, IsShiftD, IsMulD, IsDivD, Unsigned_divD;

logic [31:0] ImmExtD;
logic [2:0] Funct3D;
logic [4:0] RdD;

assign Funct3D = InstrD[14:12];
assign RdD = InstrD[11:7];

controller cont(.Op(InstrD[6:0]), .Funct3(InstrD[14:12]), .Funct7b5(InstrD[30]), .Funct7b0(InstrD[25]),
       .ALUResultSrc(ALUResultSrcD), .ResultSrc(ResultSrcD),
        .MemWrite(MemWriteD), .ALUSrc(ALUSrcD), .RegWrite(RegWriteD),
        .ImmSrc(ImmSrcD), .ALUControl(ALUControlD), .MemEn(MemEnD), .Branch(BranchD),
        .IsAdd(IsAddD), .IsBranch(IsBranchD),
        .IsLoad(IsLoadD), .IsStore(IsStoreD), .IsJump(IsJumpD), .IsShift(IsShiftD), .IsMul(IsMulD), .IsDiv(IsDivD), .Unsigned_div(Unsigned_divD));


regfile rf(.clk(clk), .WE3(RegWriteW), .A1(InstrD[19:15]), .A2(InstrD[24:20]), .A3(RdW), .WD3(ResultW), .RD1(RD1D), .RD2(RD2D));
extend ext(.Instr(InstrD[31:7]), .ImmSrc(ImmSrcD), .ImmExt(ImmExtD));


always_ff @(posedge clk) begin
    if (reset | FlushE) begin
        PCE <= 32'd0;
        Funct3E <= 3'd0;
        RdE <= 5'd0;
        RD1E <= 32'd0;
        RD2E <= 32'd0;
        ImmExtE <= 32'd0;
        InstrE <= 32'd0;
        BranchE <= 0;

        ALUResultSrcE <= 0;
        ResultSrcE <= 3'd0;
        MemWriteE <= 0;
        ALUSrcE <= 2'd0;
        RegWriteE <= 0;
        ALUControlE <= 4'd0;
        MemEnE <= 0;
        Unsigned_divE <= 0;

        IsAddE    <= 0;
        IsBranchE <= 0;
        IsLoadE   <= 0;
        IsStoreE  <= 0;
        IsJumpE   <= 0;
        IsShiftE  <= 0;
        IsMulE    <= 0;
        IsDivE <= 0;
    end

    else if (!StallD) begin
        PCE <= PCD;
        Funct3E <= Funct3D;
        RdE <= RdD;
        RD1E <= RD1D;
        RD2E <= RD2D;
        ImmExtE <= ImmExtD;
        InstrE <= InstrD;
        BranchE <= BranchD;

        ALUResultSrcE <= ALUResultSrcD;
        MemWriteE <= MemWriteD;
        ResultSrcE <= ResultSrcD;
        ALUSrcE <= ALUSrcD;
        RegWriteE <= RegWriteD;
        ALUControlE <= ALUControlD;
        MemEnE <= MemEnD;

        IsAddE    <= IsAddD;
        IsJumpE   <= IsJumpD;
        IsBranchE <= IsBranchD;
        IsLoadE   <= IsLoadD;
        IsStoreE  <= IsStoreD;
        IsShiftE  <= IsShiftD;
        IsMulE    <= IsMulD;
        IsDivE <= IsDivD;
        Unsigned_divE <= Unsigned_divD;

    end
end

endmodule
