// Load Halfword (signed) Test
// C Runtime entry point

.extern return_lh_test
.extern fail

.section .data
lh_data: .half 0x7FFF, 0xFFFF

.section .text.init
.globl lh_test
.type  lh_test, @function

lh_test:
    test1:
        la   t0, lh_data
        lh   t2, 0(t0)
        li   t3, 32767
        beq  t2, t3, test2
        j    Fail_Lh_1

    test2:
        la   t0, lh_data
        lh   t2, 2(t0)
        li   t3, -1
        beq  t2, t3, pass
        j    Fail_Lh_2

    pass:
        j return_lh_test

Fail_Lh_1:
    li   gp, 221
    j    fail

Fail_Lh_2:
    li   gp, 222
    j    fail
