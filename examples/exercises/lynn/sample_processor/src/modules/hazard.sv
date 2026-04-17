
module hazard (input  logic [4:0] Rs1E, Rs2E,
              input  logic [4:0] RdM,
              input  logic [4:0] RdW,
              input  logic       RegWriteM,
              input  logic       RegWriteW,
              input  logic [4:0] Rs1D, Rs2D,
              input  logic [4:0] RdE,
              input  logic [2:0] ResultSrcE,
              input  logic       PCSrcE, IsDivE, busy, IsMulE,
              input logic div_busy,
              output logic [1:0] ForwardAE,
              output logic [1:0] ForwardBE,
              output logic       StallF,
              output logic       StallD,
              output logic       FlushE,
              output logic       FlushD, FlushM);


logic lwStall, divStall, mulStall;
always_comb begin
    if (Rs1E != 5'b0 && Rs1E == RdM && RegWriteM)
        ForwardAE = 2'b10;
    else if (Rs1E != 5'b0 && Rs1E == RdW && RegWriteW)
        ForwardAE = 2'b01;
    else ForwardAE = 2'b00;


    if      (Rs2E != 5'b0 && Rs2E == RdM && RegWriteM)
        ForwardBE = 2'b10;
    else if (Rs2E != 5'b0 && Rs2E == RdW && RegWriteW)
        ForwardBE = 2'b01;
    else ForwardBE = 2'b00;
  end

assign lwStall = (RdE != 5'b0) && ((Rs1D == RdE) || (Rs2D == RdE)) && ((ResultSrcE == 3'b001) || (ResultSrcE == 3'b010) || (ResultSrcE == 3'b011));

assign divStall = div_busy & IsDivE;

assign mulStall = IsMulE & ((Rs1D != 5'b0 && Rs1D == RdE) || (Rs2D != 5'b0 && Rs2D == RdE));

assign StallF = lwStall | divStall | mulStall;
assign StallD = lwStall | divStall | mulStall;

assign FlushE = lwStall | mulStall | PCSrcE;
assign FlushD = PCSrcE;
assign FlushM = 1'b0;
endmodule
