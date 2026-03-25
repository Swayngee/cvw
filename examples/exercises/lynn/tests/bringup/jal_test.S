// jal test (jump and link)
// James Kaden Cassidy
// kacassidy@hmc.edu
// 1/21/2026

.extern return_jal_test
.extern fail

.section .text.init
.globl jal_test
.type  jal_test, @function

jal_test:
    test1:
        jal  t1, jal_target1
jal_return1:
        j Fail_Jal_1
jal_target1:
        la   t2, jal_return1
        beq  t1, t2, test2
        j Fail_Jal_1

    test2:
        jal  ra, jal_target2
jal_return2:
        j Fail_Jal_2
jal_target2:
        la   t0, jal_return2
        beq  ra, t0, pass
        j Fail_Jal_2

    pass:
        j return_jal_test

Fail_Jal_1:
    li   gp, 751
    j    fail

Fail_Jal_2:
    li   gp, 752
    j    fail
