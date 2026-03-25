// sw test
// James Kaden Cassidy
// kacassidy@hmc.edu
// 1/21/2026

.extern return_sw_test
.extern fail

.section .text.init
.globl sw_test
.type  sw_test, @function

sw_test:
    test1:
        la   t0, sw_data1
        li   t1, 0xA5A5A5A5
        sw   t1, 0(t0)
        lw   t2, 0(t0)
        beq  t1, t2, test2
        j Fail_Sw_1

    test2:
        la   t0, sw_data2
        li   t1, 0x11223344
        sw   t1, 0(t0)
        lw   t2, 0(t0)
        beq  t1, t2, pass
        j Fail_Sw_2

    pass:
        j return_sw_test

Fail_Sw_1:
    li   gp, 601
    j    fail

Fail_Sw_2:
    li   gp, 602
    j    fail

    .section .data
    .balign 4
sw_data1:
    .word 0
sw_data2:
    .word 0
