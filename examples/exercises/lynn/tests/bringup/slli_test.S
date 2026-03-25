// Shift Left Logical Immediate Test
// C Runtime entry point

.extern return_slli_test
.extern fail

.section .text.init
.globl slli_test
.type  slli_test, @function

slli_test:
    test1:
        li   t0, 1
        slli t2, t0, 4
        li   t3, 16
        beq  t2, t3, test2
        j    Fail_Slli_1

    test2:
        li   t0, 3
        slli t2, t0, 3
        li   t3, 24
        beq  t2, t3, pass
        j    Fail_Slli_2

    pass:
        j return_slli_test

Fail_Slli_1:
    li   gp, 111
    j    fail

Fail_Slli_2:
    li   gp, 112
    j    fail
