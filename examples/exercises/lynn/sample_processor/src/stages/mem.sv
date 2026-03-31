module mem (input  logic clk, reset,
            input  logic StallW, FlushW,

            input  logic RegWriteM, MemEn, MemWriteM,
            input  logic [1:0] ResultSrcM,

            input  logic [2:0] Funct3M,
            input  logic [31:0] IEUAdrM,
            input  logic [31:0] ALUOutM,

            input  logic [31:0] CSRDataM,
            input  logic [31:0] ReadData,
            input  logic [4:0] RdM,
            output logic [3:0] WriteByteEn,
            output logic RegWriteW,

            output logic [1:0] ResultSrcW,
            output logic [4:0] RdW,
            output logic [31:0] ALUOutW,
            output logic [31:0] CSRDataW,
            output logic [31:0] ReadDataW,
            output logic [31:0] MemFwdData);

logic [31:0] LoadData;

    always_comb begin
        if (MemEn && MemWriteM) begin
            case (Funct3M)
                3'b000: case (IEUAdrM[1:0])
                            2'b00: WriteByteEn = 4'b0001;
                            2'b01: WriteByteEn = 4'b0010;
                            2'b10: WriteByteEn = 4'b0100;
                            2'b11: WriteByteEn = 4'b1000;
                            default: WriteByteEn = 4'b0000;
                        endcase
                3'b001: case (IEUAdrM[1])
                            1'b0: WriteByteEn = 4'b0011;
                            1'b1: WriteByteEn = 4'b1100;
                            default: WriteByteEn = 4'b0000;
                        endcase
                default: WriteByteEn = 4'b1111;
            endcase
        end else WriteByteEn = 4'b0000;
    end

    always_comb begin
        case (Funct3M)
            3'b000: case (IEUAdrM[1:0])
                        2'b00: LoadData = {{24{ReadData[7]}},  ReadData[7:0]};
                        2'b01: LoadData = {{24{ReadData[15]}}, ReadData[15:8]};
                        2'b10: LoadData = {{24{ReadData[23]}}, ReadData[23:16]};
                        2'b11: LoadData = {{24{ReadData[31]}}, ReadData[31:24]};
                        default: LoadData = 32'b0;
                    endcase
            3'b001: case (IEUAdrM[1])
                        1'b0: LoadData = {{16{ReadData[15]}}, ReadData[15:0]};
                        1'b1: LoadData = {{16{ReadData[31]}}, ReadData[31:16]};
                        default: LoadData = 32'b0;
                    endcase
            3'b100: case (IEUAdrM[1:0])
                        2'b00: LoadData = {24'b0, ReadData[7:0]};
                        2'b01: LoadData = {24'b0, ReadData[15:8]};
                        2'b10: LoadData = {24'b0, ReadData[23:16]};
                        2'b11: LoadData = {24'b0, ReadData[31:24]};
                        default: LoadData = 32'b0;
                    endcase
            3'b101: case (IEUAdrM[1])
                        1'b0: LoadData = {16'b0, ReadData[15:0]};
                        1'b1: LoadData = {16'b0, ReadData[31:16]};
                        default: LoadData = 32'b0;
                    endcase
            default: LoadData = ReadData;
        endcase
    end

    assign MemFwdData = LoadData;

always_ff @(posedge clk) begin
    if (reset | FlushW) begin
        RegWriteW  <= 1'b0;
        ResultSrcW <= 2'b00;
        ALUOutW    <= 32'd0;

        RdW        <= 5'd0;
        CSRDataW   <= 32'd0;
        ReadDataW  <= 32'd0;
end
    else if (!StallW) begin
        RegWriteW  <= RegWriteM;
        ResultSrcW <= ResultSrcM;
        ALUOutW    <= ALUOutM;
        RdW        <= RdM;
        CSRDataW   <= CSRDataM;
        ReadDataW  <= LoadData;
end
end
endmodule
