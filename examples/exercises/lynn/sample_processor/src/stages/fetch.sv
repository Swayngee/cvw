module fetch(input logic  clk, reset,
        input logic [31:0] Instr,
        input logic StallF, StallD, FlushD,
        input logic PCSrc,
        input logic [31:0]    IEUAdr,
        output logic [31:0]    PCD,
        output logic [31:0] PCF,
        output logic [31:0] InstrD);

// PC logic
    logic [31:0] PCNext;
    logic [31:0] PCPlus4;
    // next PC logic
    // Default matches linker FLASH/RAM base (see tb/testbench `ELF_BASE_ADR`); avoids PC=0
    // fetches that are below IMEM offset and would trigger ram1p1rwb out-of-range.
    logic [31:0] entry_addr;
    initial begin
        entry_addr = 32'h8000_0000;

        // override if provided (+ENTRY_ADDR=...)
        void'($value$plusargs("ENTRY_ADDR=%h", entry_addr));

        $display("[TB] ENTRY_ADDR = 0x%h", entry_addr);
    end

    always_ff @(posedge clk or posedge reset) begin
    if (reset)  PCF <= entry_addr;
    else if (!StallF)     PCF <= PCNext;
    end

    adder pcadd4(PCF, 32'd4, PCPlus4);
    mux2 #(32) pcmux(PCPlus4, {IEUAdr[31:1], 1'b0}, PCSrc, PCNext);

// Pipelined reg 1
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
