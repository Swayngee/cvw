// Set Less Than Unsigned Test
// C Runtime entry point

.extern return_sltu_test
.extern fail

.section .text.init
.globl sltu_test
.type  sltu_test, @function

sltu_test:
    test1:
        li   t0, 3
        li   t1, 10
        sltu t2, t0, t1
        li   t3, 1
        beq  t2, t3, test2
        j    Fail_Sltu_1

    test2:
        li   t0, 10
        li   t1, 3
        sltu t2, t0, t1
        li   t3, 0
        beq  t2, t3, pass
        j    Fail_Sltu_2

    pass:
        j return_sltu_test

Fail_Sltu_1:
    li   gp, 161
    j    fail

Fail_Sltu_2:
    li   gp, 162
    j    fail
