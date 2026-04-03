



module cmp(
    input  logic [31:0] R1, R2,
    output logic        Eq,
    output logic        LT,
    output logic        LTU
);

    assign Eq  = (R1 == R2);
    assign LT  = ($signed(R1) < $signed(R2));
    assign LTU = (R1 < R2);

endmodule
