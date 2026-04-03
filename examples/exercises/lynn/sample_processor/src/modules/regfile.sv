



module regfile(input   logic           clk,
        input   logic           WE3,
        input logic [31:0] PC,
        input logic [31:0] Instr,
        input   logic [4:0]     A1, A2, A3,
        input   logic [31:0]    WD3,
        output  logic [31:0]    RD1, RD2
    );

logic [31:0] rf[31:1];

    
    
    
    
always_ff @(posedge clk) begin
    if (WE3 && A3 != 5'b0)begin
        rf[A3] <= WD3;
        
    end
    
    end


    




assign RD1 = (A1 == 5'd0) ? 32'd0 :
             ((WE3 && (A1 == A3) && (A3 != 5'd0)) ? WD3 : rf[A1]);
assign RD2 = (A2 == 5'd0) ? 32'd0 :
             ((WE3 && (A2 == A3) && (A3 != 5'd0)) ? WD3 : rf[A2]);

endmodule
