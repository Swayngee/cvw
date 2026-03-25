// lw test
// James Kaden Cassidy
// kacassidy@hmc.edu
// 1/21/2026

.extern return_lw_test
.extern fail

.section .text.init
.globl lw_test
.type  lw_test, @function

lw_test:
    test1:
        la   t0, lw_data1
        lw   t1, 0(t0)
        li   t2, 0x12345678
        beq  t1, t2, test2
        j Fail_Lw_1

    test2:
        la   t0, lw_data2
        lw   t1, 0(t0)
        li   t2, 0xDEADBEEF
        beq  t1, t2, pass
        j Fail_Lw_2

    pass:
        j return_lw_test

Fail_Lw_1:
    li   gp, 501
    j    fail

Fail_Lw_2:
    li   gp, 502
    j    fail

    .section .data
lw_data1:
    .word 0x12345678
lw_data2:
    .word 0xDEADBEEF
