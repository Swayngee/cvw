// C Runtime entry point
// James Kaden Cassidy
// kacassidy@hmc.edu
// 1/21/2026

.extern return_beq_test
.extern fail

.section .text.init
.globl beq_test
.type  beq_test, @function

beq_test:

    test1:
        li   t0, 10
        li   t1, 10
        beq  t0, t1, test2     // should branch
        j Fail_BEQ_1

    test2:
        li   t0, 5
        li   t1, 7
        beq  t0, t1, Fail_BEQ_2   // should NOT branch
        j pass

    pass:
        j return_beq_test

Fail_BEQ_1:
        li   gp, 1201
        j    fail

Fail_BEQ_2:
        li   gp, 1202
        j    fail
