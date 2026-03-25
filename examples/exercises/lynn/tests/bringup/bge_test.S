// Branch Greater Than or Equal (signed) Test
// C Runtime entry point

.extern return_bge_test
.extern fail

.section .text.init
.globl bge_test
.type  bge_test, @function

bge_test:
    test1:
        li   t0, 5
        li   t1, 5
        bge  t0, t1, test2   # should branch (5 >= 5)
        j    Fail_Bge_1

    test2:
        li   t0, -1
        li   t1, 0
        bge  t0, t1, Fail_Bge_2  # should NOT branch (-1 < 0)
        j    pass

    pass:
        j return_bge_test

Fail_Bge_1:
    li   gp, 291
    j    fail

Fail_Bge_2:
    li   gp, 292
    j    fail
