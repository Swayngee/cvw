// slt test (set less than)
// James Kaden Cassidy
// kacassidy@hmc.edu
// 1/21/2026

.extern return_slt_test
.extern fail

.section .text.init
.globl slt_test
.type  slt_test, @function

slt_test:
    test1:
        li   t0, 5
        li   t1, 10
        slt  t2, t0, t1
        li   t3, 1
        beq  t2, t3, test2
        j Fail_Slt_1

    test2:
        li   t0, 20
        li   t1, 7
        slt  t2, t0, t1
        li   t3, 0
        beq  t2, t3, pass
        j Fail_Slt_2

    pass:
        j return_slt_test

Fail_Slt_1:
    li   gp, 801
    j    fail

Fail_Slt_2:
    li   gp, 802
    j    fail
