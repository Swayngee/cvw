// xor test
// James Kaden Cassidy
// kacassidy@hmc.edu
// 1/21/2026

.extern return_xor_test
.extern fail

.section .text.init
.globl xor_test
.type  xor_test, @function

xor_test:
    test1:
        li   t0, 0xFF
        li   t1, 0x0F
        xor  t2, t0, t1
        li   t3, 0xF0
        beq  t2, t3, test2
        j Fail_Xor_1

    test2:
        li   t0, 0x55
        li   t1, 0xAA
        xor  t2, t0, t1
        li   t3, 0xFF
        beq  t2, t3, pass
        j Fail_Xor_2

    pass:
        j return_xor_test

Fail_Xor_1:
    li   gp, 551
    j    fail

Fail_Xor_2:
    li   gp, 552
    j    fail
