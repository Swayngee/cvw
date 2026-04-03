



module adder (
        input   logic [31:0]   inputA, inputB,
        output  logic [31:0]   result
    );

    assign result = inputA + inputB;

endmodule
