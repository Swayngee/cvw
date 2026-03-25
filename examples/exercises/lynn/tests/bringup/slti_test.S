// slti test (set less than immediate)
// James Kaden Cassidy
// kacassidy@hmc.edu
// 1/21/2026

.extern return_slti_test
.extern fail

.section .text.init
.globl slti_test
.type  slti_test, @function

slti_test:
    test1:
        li   t0, 3
        slti t1, t0, 8
        li   t2, 1
        beq  t1, t2, test2
        j Fail_Slti_1

    test2:
        li   t0, 15
        slti t1, t0, 10
        li   t2, 0
        beq  t1, t2, pass
        j Fail_Slti_2

    pass:
        j return_slti_test

Fail_Slti_1:
    li   gp, 811
    j    fail

Fail_Slti_2:
    li   gp, 812
    j    fail
