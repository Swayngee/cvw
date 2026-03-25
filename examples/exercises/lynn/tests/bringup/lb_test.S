// Load Byte (signed) Test
// C Runtime entry point

.extern return_lb_test
.extern fail

.section .data
lb_data: .byte 0x7F, 0xFF   # 127 and -1 (signed)

.section .text.init
.globl lb_test
.type  lb_test, @function

lb_test:
    test1:
        la   t0, lb_data
        lb   t2, 0(t0)
        li   t3, 127
        beq  t2, t3, test2
        j    Fail_Lb_1

    test2:
        la   t0, lb_data
        lb   t2, 1(t0)
        li   t3, -1
        beq  t2, t3, pass
        j    Fail_Lb_2

    pass:
        j return_lb_test

Fail_Lb_1:
    li   gp, 201
    j    fail

Fail_Lb_2:
    li   gp, 202
    j    fail
