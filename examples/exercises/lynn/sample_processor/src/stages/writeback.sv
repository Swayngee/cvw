module writeback(input logic [1:0] ResultSrcW,
                input logic [31:0] CSRDataW,
                input logic [31:0] ALUOutW, ReadDataW,
                output logic [31:0] ResultW);

always_comb begin
    case(ResultSrcW)
        2'b00:   ResultW = ALUOutW;
        2'b01:   ResultW = ReadDataW;
        2'b10:   ResultW = CSRDataW;
        default: ResultW = 32'd0;
    endcase

end
endmodule
