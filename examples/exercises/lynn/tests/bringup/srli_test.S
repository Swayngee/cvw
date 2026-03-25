// Shift Right Logical Immediate Test
// C Runtime entry point

.extern return_srli_test
.extern fail

.section .text.init
.globl srli_test
.type  srli_test, @function

srli_test:
    test1:
        li   t0, 16
        srli t2, t0, 2
        li   t3, 4
        beq  t2, t3, test2
        j    Fail_Srli_1

    test2:
        li   t0, 64
        srli t2, t0, 4
        li   t3, 4
        beq  t2, t3, pass
        j    Fail_Srli_2

    pass:
        j return_srli_test

Fail_Srli_1:
    li   gp, 131
    j    fail

Fail_Srli_2:
    li   gp, 132
    j    fail
