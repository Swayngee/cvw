// Shift Right Arithmetic Immediate Test
// C Runtime entry point

.extern return_srai_test
.extern fail

.section .text.init
.globl srai_test
.type  srai_test, @function

srai_test:
    test1:
        li   t0, -16
        srai t2, t0, 2
        li   t3, -4
        beq  t2, t3, test2
        j    Fail_Srai_1

    test2:
        li   t0, 32
        srai t2, t0, 3
        li   t3, 4
        beq  t2, t3, pass
        j    Fail_Srai_2

    pass:
        j return_srai_test

Fail_Srai_1:
    li   gp, 151
    j    fail

Fail_Srai_2:
    li   gp, 152
    j    fail
