// Store Byte Test
// C Runtime entry point

.extern return_sb_test
.extern fail

.section .data
sb_data: .byte 0x00, 0x00

.section .text.init
.globl sb_test
.type  sb_test, @function

sb_test:
    test1:
        la   t0, sb_data
        li   t1, 0x42
        sb   t1, 0(t0)
        lb   t2, 0(t0)
        li   t3, 0x42
        beq  t2, t3, test2
        j    Fail_Sb_1

    test2:
        la   t0, sb_data
        li   t1, 0x7F
        sb   t1, 1(t0)
        lb   t2, 1(t0)
        li   t3, 0x7F
        beq  t2, t3, pass
        j    Fail_Sb_2

    pass:
        j return_sb_test

Fail_Sb_1:
    li   gp, 241
    j    fail

Fail_Sb_2:
    li   gp, 242
    j    fail
