
module hazard (input  logic [4:0] Rs1E, Rs2E,
              input  logic [4:0] RdM,
              input  logic [4:0] RdW,
              input  logic       RegWriteM,
              input  logic       RegWriteW,
              input  logic [4:0] Rs1D, Rs2D,
              input  logic [4:0] RdE,
              input  logic [1:0] ResultSrcE,
              input  logic       PCSrcE,
              output logic [1:0] ForwardAE,
              output logic [1:0] ForwardBE,
              output logic       StallF,
              output logic       StallD,
              output logic       FlushE,
              output logic       FlushD);


logic lwStall;
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

    
    
    assign lwStall = (((Rs1D != 5'b0) && (Rs1D == RdE)) | ((Rs2D != 5'b0) && (Rs2D == RdE))) & (ResultSrcE == 2'b01);
    assign StallF = lwStall;
    assign StallD = lwStall;
    
    assign FlushE = lwStall | PCSrcE;
    assign FlushD = PCSrcE;

endmodule
