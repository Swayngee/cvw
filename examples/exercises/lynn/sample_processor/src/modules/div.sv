module div (
    input  logic        clk, reset,
    input  logic        div,
    input  logic        is_unsigned,
    input  logic [31:0] SrcA,
    input  logic [31:0] SrcB,
    output logic [31:0] Quotient,
    output logic [31:0] Remainder,
    output logic        busy
);

    logic [31:0] Remain, R_temp, Q_temp, Divisor, abs_A, abs_B;
    logic [4:0]  Count;
    logic        sign_Q, sign_R;


    typedef enum logic [1:0] {idle, calc, apply_sign, done} statetype;
    statetype state, nextstate;

    always_comb begin
        abs_A = (SrcA[31] & ~is_unsigned) ? (~SrcA + 1'b1) : SrcA;
        abs_B = (SrcB[31] & ~is_unsigned) ? (~SrcB + 1'b1) : SrcB;
        R_temp = (Remain << 1) | {31'b0, Quotient[31]};
        Q_temp = (Quotient << 1);
    end

    always_comb begin
        nextstate = state;
        busy = 1'b0;
        case(state)
            idle: begin
                if (div) begin
                    if (SrcB == 32'd0) nextstate = done;
                    else               nextstate = calc;
                    busy = 1'b1;
                end
                else nextstate = idle;
            end

            calc: begin
            busy = 1'b1;
                if (Count == 5'd0) nextstate = apply_sign;
                else begin
                    nextstate = calc;
                end
            end

            apply_sign: begin
                nextstate = done;
                busy = 1'b1;
            end

            done: begin
                nextstate = idle;
                busy = 1'b0;
            end
            default: nextstate = idle;
        endcase
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= idle;
            Count <= 5'd0;
            Quotient <= 32'd0;
            Remain <= 32'd0;
            Divisor <= 32'd0;
        end else begin
            state <= nextstate;
            case(state)
                idle: begin
                    if (div) begin
                        if (SrcB == 32'd0) begin
                            Quotient <= 32'hFFFFFFFF;
                            Remain   <= SrcA;
                        end else begin

                        Quotient <= abs_A;
                        Remain   <= 32'd0;
                        Divisor  <= abs_B;
                        sign_Q   <= (is_unsigned) ? 1'b0 : (SrcA[31] ^ SrcB[31]);
                        sign_R   <= (is_unsigned) ? 1'b0 : SrcA[31];
                        Count    <= 5'd31;
                    end
                end
            end
                calc: begin
                    if (R_temp >= Divisor) begin
                        Remain   <= R_temp - Divisor;
                        Quotient <= Q_temp | 32'd1;
                    end
                    else begin
                        Remain   <= R_temp;
                        Quotient <= Q_temp;
                    end
                    Count <= Count - 5'd1;
                end

                apply_sign: begin
                    if (sign_Q) Quotient <= ~Quotient + 1'b1;
                    if (sign_R) Remain   <= ~Remain + 1'b1;
                end

            endcase
        end
    end

    assign Remainder = Remain;
endmodule
