// riscvsingle.sv
// RISC-V single-cycle processor
// David_Harris@hmc.edu 2020

module regfile(input   logic           clk,
        input   logic           WE3,
        input logic [31:0] PC, //for debug
        input logic [31:0] Instr, // for debug
        input   logic [4:0]     A1, A2, A3,
        input   logic [31:0]    WD3,
        output  logic [31:0]    RD1, RD2
    );

logic [31:0] rf[31:1];

    // three ported register file
    // read two ports combinationally (A1/RD1, A2/RD2)
    // write third port on rising edge of clock (A3/WD3/WE3)
    // register 0 hardwired to 0
always_ff @(posedge clk) begin
    if (WE3 && A3 != 5'b0)begin
        rf[A3] <= WD3;
        //$display("[RF] PC=%0h | x%0d <= %0h", PC, A3, WD3);
    end
    //else if (WE3 && (A3 == 5'd2)) $display("[SP] PC=%0h | sp <= %0h", PC, WD3);
    end

//always_ff @(posedge clk) begin
    //$display("PC=%h Instr=%h Op=%b", PC, Instr, Instr[6:0]);
//end

assign RD1 = (A1 != 0) ? rf[A1] : 32'd0;
assign RD2 = (A2 != 0) ? rf[A2] : 32'd0;

endmodule
