module alu(
    input  logic [31:0] SrcA, SrcB,
    input  logic [3:0]  ALUControl,
    output logic [31:0] ALUResult, IEUAdr
);
    logic [31:0] Sum;
    logic [31:0] shift_result;
    logic [4:0]  shamt;

    assign shamt = SrcB[4:0];
    assign Sum = SrcA + (ALUControl[0] ? ~SrcB : SrcB) + ALUControl[0];
    assign IEUAdr = Sum;

    always_comb begin
        case (ALUControl)
            4'b0111: shift_result = SrcA << shamt;
            4'b1000: shift_result = SrcA >> shamt;
            4'b1001: shift_result = $signed(SrcA) >>> shamt;
            default: shift_result = 32'b0;
        endcase
    end

    always_comb begin
        case (ALUControl)
            4'b0000: ALUResult = SrcA + SrcB;
            4'b0001: ALUResult = SrcA - SrcB;
            4'b0010: ALUResult = SrcA & SrcB;
            4'b0011: ALUResult = SrcA | SrcB;
            4'b0100: ALUResult = SrcA ^ SrcB;
            4'b0101: ALUResult = ($signed(SrcA) < $signed(SrcB)) ? 32'd1 : 32'd0;
            4'b0110: ALUResult = (SrcA < SrcB) ? 32'd1 : 32'd0;
            4'b0111,
            4'b1000,
            4'b1001: ALUResult = shift_result;
            default: ALUResult = 32'b0;
        endcase
    end
endmodule