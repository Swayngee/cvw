// Shift Right Arithmetic Test
// C Runtime entry point

.extern return_sra_test
.extern fail

.section .text.init
.globl sra_test
.type  sra_test, @function

sra_test:
    test1:
        li   t0, -8
        li   t1, 2
        sra  t2, t0, t1
        li   t3, -2
        beq  t2, t3, test2
        j    Fail_Sra_1

    test2:
        li   t0, 16
        li   t1, 2
        sra  t2, t0, t1
        li   t3, 4
        beq  t2, t3, pass
        j    Fail_Sra_2

    pass:
        j return_sra_test

Fail_Sra_1:
    li   gp, 141
    j    fail

Fail_Sra_2:
    li   gp, 142
    j    fail
