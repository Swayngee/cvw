// andi test
// James Kaden Cassidy
// kacassidy@hmc.edu
// 1/21/2026

.extern return_andi_test
.extern fail

.section .text.init
.globl andi_test
.type  andi_test, @function

andi_test:
    test1:
        li   t0, 0xFF
        andi t1, t0, 0x0F
        li   t2, 0x0F
        beq  t1, t2, test2
        j Fail_Andi_1

    test2:
        li   t0, 0x3C
        andi t1, t0, 0xC3
        li   t2, 0x00
        beq  t1, t2, pass
        j Fail_Andi_2

    pass:
        j return_andi_test

Fail_Andi_1:
    li   gp, 251
    j    fail

Fail_Andi_2:
    li   gp, 252
    j    fail
