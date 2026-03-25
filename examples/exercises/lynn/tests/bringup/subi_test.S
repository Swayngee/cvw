// C Runtime entry point
// James Kaden Cassidy
// kacassidy@hmc.edu
// 1/21/2026

.extern return_subi_test
.extern fail

.section .text.init
.globl subi_test
.type  subi_test, @function

subi_test:

    test1:
        li   t0, 10
        addi t2, t0, -4      // 10 - 4 = 6
        li   t3, 6
        beq  t2, t3, test2
        j Fail_SUBI_1

    test2:
        li   t0, 25
        addi t2, t0, -7      // 25 - 7 = 18
        li   t3, 18
        beq  t2, t3, pass
        j Fail_SUBI_2

    pass:
        j return_subi_test

Fail_SUBI_1:
        li   gp, 601
        j    fail

Fail_SUBI_2:
        li   gp, 602
        j    fail
