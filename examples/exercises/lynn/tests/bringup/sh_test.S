// Store Halfword Test
// C Runtime entry point

.extern return_sh_test
.extern fail

.section .data
sh_data: .half 0x0000, 0x0000

.section .text.init
.globl sh_test
.type  sh_test, @function

sh_test:
    test1:
        la   t0, sh_data
        li   t1, 0x1234
        sh   t1, 0(t0)
        lh   t2, 0(t0)
        li   t3, 0x1234
        beq  t2, t3, test2
        j    Fail_Sh_1

    test2:
        la   t0, sh_data
        li   t1, 0x7FFF
        sh   t1, 2(t0)
        lh   t2, 2(t0)
        li   t3, 0x7FFF
        beq  t2, t3, pass
        j    Fail_Sh_2

    pass:
        j return_sh_test

Fail_Sh_1:
    li   gp, 251
    j    fail

Fail_Sh_2:
    li   gp, 252
    j    fail
