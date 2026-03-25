// Load Halfword Unsigned Test
// C Runtime entry point

.extern return_lhu_test
.extern fail

.section .data
lhu_data: .half 0xFFFF, 0x0001

.section .text.init
.globl lhu_test
.type  lhu_test, @function

lhu_test:
    test1:
        la   t0, lhu_data
        lhu  t2, 0(t0)
        li   t3, 65535
        beq  t2, t3, test2
        j    Fail_Lhu_1

    test2:
        la   t0, lhu_data
        lhu  t2, 2(t0)
        li   t3, 1
        beq  t2, t3, pass
        j    Fail_Lhu_2

    pass:
        j return_lhu_test

Fail_Lhu_1:
    li   gp, 231
    j    fail

Fail_Lhu_2:
    li   gp, 232
    j    fail
