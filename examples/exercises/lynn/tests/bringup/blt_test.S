// Branch Less Than (signed) Test
// C Runtime entry point

.extern return_blt_test
.extern fail

.section .text.init
.globl blt_test
.type  blt_test, @function

blt_test:
    test1:
        li   t0, -1
        li   t1, 1
        blt  t0, t1, test2   # should branch (-1 < 1)
        j    Fail_Blt_1

    test2:
        li   t0, 5
        li   t1, 3
        blt  t0, t1, Fail_Blt_2  # should NOT branch (5 > 3)
        j    pass

    pass:
        j return_blt_test

Fail_Blt_1:
    li   gp, 271
    j    fail

Fail_Blt_2:
    li   gp, 272
    j    fail
