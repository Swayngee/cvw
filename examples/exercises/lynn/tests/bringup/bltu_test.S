// Branch Less Than Unsigned Test
// C Runtime entry point

.extern return_bltu_test
.extern fail

.section .text.init
.globl bltu_test
.type  bltu_test, @function

bltu_test:
    test1:
        li   t0, 3
        li   t1, 10
        bltu t0, t1, test2   # should branch (3 < 10 unsigned)
        j    Fail_Bltu_1

    test2:
        li   t0, 10
        li   t1, 3
        bltu t0, t1, Fail_Bltu_2  # should NOT branch
        j    pass

    pass:
        j return_bltu_test

Fail_Bltu_1:
    li   gp, 281
    j    fail

Fail_Bltu_2:
    li   gp, 282
    j    fail
