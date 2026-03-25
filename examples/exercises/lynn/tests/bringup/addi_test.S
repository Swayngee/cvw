// addi test (addi and "subi" via addi with negative immediate)
// James Kaden Cassidy
// kacassidy@hmc.edu
// 1/21/2026

.extern return_addi_test
.extern fail

.section .text.init
.globl addi_test
.type  addi_test, @function

addi_test:
    test1:
        li   t0, 100
        addi t1, t0, 42
        li   t2, 142
        beq  t1, t2, test2
        j Fail_Addi_1

    test2:
        li   t0, 50
        addi t1, t0, -17
        li   t2, 33
        beq  t1, t2, pass
        j Fail_Addi_2

    pass:
        j return_addi_test

Fail_Addi_1:
    li   gp, 351
    j    fail

Fail_Addi_2:
    li   gp, 352
    j    fail
