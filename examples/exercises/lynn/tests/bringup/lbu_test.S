// Load Byte Unsigned Test
// C Runtime entry point

.extern return_lbu_test
.extern fail

.section .data
lbu_data: .byte 0xFF, 0x01

.section .text.init
.globl lbu_test
.type  lbu_test, @function

lbu_test:
    test1:
        la   t0, lbu_data
        lbu  t2, 0(t0)
        li   t3, 255
        beq  t2, t3, test2
        j    Fail_Lbu_1

    test2:
        la   t0, lbu_data
        lbu  t2, 1(t0)
        li   t3, 1
        beq  t2, t3, pass
        j    Fail_Lbu_2

    pass:
        j return_lbu_test

Fail_Lbu_1:
    li   gp, 211
    j    fail

Fail_Lbu_2:
    li   gp, 212
    j    fail
