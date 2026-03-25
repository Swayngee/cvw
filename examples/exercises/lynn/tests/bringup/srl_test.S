// Shift Right Logical Test
// C Runtime entry point

.extern return_srl_test
.extern fail

.section .text.init
.globl srl_test
.type  srl_test, @function

srl_test:
    test1:
        li   t0, 16
        li   t1, 2
        srl  t2, t0, t1
        li   t3, 4
        beq  t2, t3, test2
        j    Fail_Srl_1

    test2:
        li   t0, 32
        li   t1, 3
        srl  t2, t0, t1
        li   t3, 4
        beq  t2, t3, pass
        j    Fail_Srl_2

    pass:
        j return_srl_test

Fail_Srl_1:
    li   gp, 121
    j    fail

Fail_Srl_2:
    li   gp, 122
    j    fail
