// ori test
// James Kaden Cassidy
// kacassidy@hmc.edu
// 1/21/2026

.extern return_ori_test
.extern fail

.section .text.init
.globl ori_test
.type  ori_test, @function

ori_test:
    test1:
        li   t0, 0x0F
        ori  t1, t0, 0xF0
        li   t2, 0xFF
        beq  t1, t2, test2
        j Fail_Ori_1

    test2:
        li   t0, 0x33
        ori  t1, t0, 0xCC
        li   t2, 0xFF
        beq  t1, t2, pass
        j Fail_Ori_2

    pass:
        j return_ori_test

Fail_Ori_1:
    li   gp, 151
    j    fail

Fail_Ori_2:
    li   gp, 152
    j    fail
