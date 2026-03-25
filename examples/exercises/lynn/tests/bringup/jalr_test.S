// Jump and Link Register Test
// C Runtime entry point

.extern return_jalr_test
.extern fail

.section .text.init
.globl jalr_test
.type  jalr_test, @function

jalr_test:
    test1:
        la   t0, target1
        jalr ra, t0, 0       # jump to target1, store return addr in ra
        j    Fail_Jalr_1     # should be skipped

    target1:
        # verify ra points back to instruction after jalr (j Fail_Jalr_1)
        # just continue to test2
        j    test2

    test2:
        la   t0, target2
        jalr ra, t0, 0
        j    Fail_Jalr_2

    target2:
        j    pass

    pass:
        j return_jalr_test

Fail_Jalr_1:
    li   gp, 311
    j    fail

Fail_Jalr_2:
    li   gp, 312
    j    fail
