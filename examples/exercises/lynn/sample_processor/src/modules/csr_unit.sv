module csr_unit(
    input  logic        clk, reset,
    input  logic [11:0] csr_addr,
    input  logic        is_add, is_branch_eval, is_branch_taken, is_load, is_store, is_jump, is_shift, is_mul,
    output logic [31:0] csr_data
);
    logic [63:0] cycle_count, insret_count, add_count, branch_eval_count, branch_taken_count;
    logic [63:0] load_count, store_count, jump_count, shift_count, mul_count;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            cycle_count <= 0; insret_count <= 0; add_count <= 0; branch_eval_count <= 0;
            branch_taken_count <= 0; load_count <= 0; store_count <= 0; jump_count <= 0;
            shift_count <= 0; mul_count <= 0;
        end else begin
            cycle_count  <= cycle_count + 1'b1;
            insret_count <= insret_count + 1'b1;
            if (is_add)          add_count          <= add_count + 1'b1;
            if (is_branch_eval)  branch_eval_count  <= branch_eval_count + 1'b1;
            if (is_branch_taken) branch_taken_count <= branch_taken_count + 1'b1;
            if (is_load)         load_count         <= load_count + 1'b1;
            if (is_store)        store_count        <= store_count + 1'b1;
            if (is_jump)         jump_count         <= jump_count + 1'b1;
            if (is_shift)        shift_count        <= shift_count + 1'b1;
            if (is_mul)          mul_count          <= mul_count + 1'b1;
        end
    end

    always_comb begin
        case (csr_addr)
            12'hC00, 12'hB00, 12'hC01, 12'hB01: csr_data = cycle_count[31:0];
            12'hC02, 12'hB02:                   csr_data = insret_count[31:0];
            12'hC03, 12'hB03:                   csr_data = add_count[31:0];
            12'hC04, 12'hB04:                   csr_data = branch_eval_count[31:0];
            12'hC05, 12'hB05:                   csr_data = branch_taken_count[31:0];
            12'hC06, 12'hB06:                   csr_data = load_count[31:0];
            12'hC07, 12'hB07:                   csr_data = store_count[31:0];
            12'hC08, 12'hB08:                   csr_data = jump_count[31:0];
            12'hC09, 12'hB09:                   csr_data = mul_count[31:0];
            12'hC0A, 12'hB0A:                   csr_data = shift_count[31:0];
            12'hC80, 12'hB80, 12'hC81, 12'hB81: csr_data = cycle_count[63:32];
            12'hC82, 12'hB82:                   csr_data = insret_count[63:32];
            default:                            csr_data = 32'd0;
        endcase
    end
endmodule
