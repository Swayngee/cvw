// Load Upper Immediate Test
// C Runtime entry point

.extern return_lui_test
.extern fail

.section .text.init
.globl lui_test
.type  lui_test, @function

lui_test:
    test1:
        lui  t2, 1           # t2 = 1 << 12 = 4096
        li   t3, 4096
        beq  t2, t3, test2
        j    Fail_Lui_1

    test2:
        lui  t2, 0xABCDE     # t2 = 0xABCDE000
        li   t3, 0xABCDE000
        beq  t2, t3, pass
        j    Fail_Lui_2

    pass:
        j return_lui_test

Fail_Lui_1:
    li   gp, 321
    j    fail

Fail_Lui_2:
    li   gp, 322
    j    fail
