// Set Less Than Immediate Unsigned Test
// C Runtime entry point

.extern return_sltiu_test
.extern fail

.section .text.init
.globl sltiu_test
.type  sltiu_test, @function

sltiu_test:
    test1:
        li    t0, 3
        sltiu t2, t0, 10
        li    t3, 1
        beq   t2, t3, test2
        j     Fail_Sltiu_1

    test2:
        li    t0, 10
        sltiu t2, t0, 3
        li    t3, 0
        beq   t2, t3, pass
        j     Fail_Sltiu_2

    pass:
        j return_sltiu_test

Fail_Sltiu_1:
    li   gp, 171
    j    fail

Fail_Sltiu_2:
    li   gp, 172
    j    fail
