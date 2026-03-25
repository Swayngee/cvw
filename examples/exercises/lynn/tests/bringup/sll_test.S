// Shift Left Logical Test
// C Runtime entry point

.extern return_sll_test
.extern fail

.section .text.init
.globl sll_test
.type  sll_test, @function

sll_test:
    test1:
        li   t0, 1
        li   t1, 3
        sll  t2, t0, t1
        li   t3, 8
        beq  t2, t3, test2
        j    Fail_Sll_1

    test2:
        li   t0, 5
        li   t1, 2
        sll  t2, t0, t1
        li   t3, 20
        beq  t2, t3, pass
        j    Fail_Sll_2

    pass:
        j return_sll_test

Fail_Sll_1:
    li   gp, 101
    j    fail

Fail_Sll_2:
    li   gp, 102
    j    fail
