// Branch Greater Than or Equal Unsigned Test
// C Runtime entry point

.extern return_bgeu_test
.extern fail

.section .text.init
.globl bgeu_test
.type  bgeu_test, @function

bgeu_test:
    test1:
        li   t0, 10
        li   t1, 10
        bgeu t0, t1, test2   # should branch (10 >= 10 unsigned)
        j    Fail_Bgeu_1

    test2:
        li   t0, 2
        li   t1, 5
        bgeu t0, t1, Fail_Bgeu_2  # should NOT branch (2 < 5)
        j    pass

    pass:
        j return_bgeu_test

Fail_Bgeu_1:
    li   gp, 301
    j    fail

Fail_Bgeu_2:
    li   gp, 302
    j    fail
