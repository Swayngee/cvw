// riscvsingle.sv
// RISC-V single-cycle processor
// David_Harris@hmc.edu 2020

module cmp(
    input  logic [31:0] R1, R2,
    output logic        Eq,
    output logic        LT,  // Less Than (Signed)
    output logic        LTU  // Less Than Unsigned
);

    assign Eq  = (R1 == R2);
    assign LT  = ($signed(R1) < $signed(R2));
    assign LTU = (R1 < R2);

endmodule
