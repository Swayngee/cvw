module fetch(input logic  clk, reset,
        input logic [31:0] Instr,
        input logic StallF, StallD, FlushD,
        input logic PCSrc,
        input logic [31:0]    IEUAdr,
        output logic [31:0]    PCD,
        output logic [31:0] PCF,
        output logic [31:0] InstrD);


    logic [31:0] PCNext;
    logic [31:0] PCPlus4;
    
    
    
    logic [31:0] entry_addr;
    initial begin
        entry_addr = 32'h8000_0000;

        
        void'($value$plusargs("ENTRY_ADDR=%h", entry_addr));

        $display("[TB] ENTRY_ADDR = 0x%h", entry_addr);
    end

    always_ff @(posedge clk or posedge reset) begin
    if (reset)  PCF <= entry_addr;
    else if (!StallF)     PCF <= PCNext;
    end

    adder pcadd4(PCF, 32'd4, PCPlus4);
    mux2 #(32) pcmux(PCPlus4, {IEUAdr[31:1], 1'b0}, PCSrc, PCNext);


always_ff @(posedge clk) begin
    if (reset | FlushD) begin
       InstrD <= 32'd0;
        PCD <= 32'd0;
    end
    else if (!StallD) begin
        InstrD <= Instr;
        PCD <= PCF;
    end
end
endmodule
