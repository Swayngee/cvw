// xori test
// James Kaden Cassidy
// kacassidy@hmc.edu
// 1/21/2026

.extern return_xori_test
.extern fail

.section .text.init
.globl xori_test
.type xori_test, @function

xori_test:
    test1:
        li   t0, 0xCC
        xori t1, t0, 0x33
        li   t2, 0xFF
        beq  t1, t2, test2
        j Fail_Xori_1

    test2:
        li   t0, 0x00
        xori t1, t0, 0xFF
        li   t2, 0xFF
        beq  t1, t2, test3
        j Fail_Xori_2

    test3:
        li   t0, 0xFF
        xori t1, t0, 0xFF
        li   t2, 0x00
        beq  t1, t2, test4
        j Fail_Xori_3

    test4:
        li   t0, 0xAA
        xori t1, t0, 0x55
        li   t2, 0xFF
        beq  t1, t2, test5
        j Fail_Xori_4

    test5:
        li   t0, 0xF0
        xori t1, t0, 0x0F
        li   t2, 0xFF
        beq  t1, t2, test6
        j Fail_Xori_5

    test6:
        li   t0, 0x00
        xori t1, t0, 0x00
        li   t2, 0x00
        beq  t1, t2, test7
        j Fail_Xori_6

    test7:
        li   t0, 0x1
        xori t1, t0, 0x1
        li   t2, 0x0
        beq  t1, t2, test8
        j Fail_Xori_7

    test8:
        li   t0, 0x0F
        xori t1, t0, 0x00
        li   t2, 0x0F
        beq  t1, t2, test9
        j Fail_Xori_8

    test9:
        li   t0, 0x5A
        xori t1, t0, 0x5A
        li   t2, 0x00
        beq  t1, t2, test10
        j Fail_Xori_9

    test10:
        li   t0, 0x7F
        xori t1, t0, 0x01
        li   t2, 0x7E
        beq  t1, t2, test11
        j Fail_Xori_10

    test11:
        li   t0, 0x12
        xori t1, t0, 0x34
        li   t2, 0x26
        beq  t1, t2, test12
        j Fail_Xori_11

    test12:
        li   t0, 0xAB
        xori t1, t0, 0x0F
        li   t2, 0xA4
        beq  t1, t2, test13
        j Fail_Xori_12

    test13:
        li   t0, 0xFF
        xori t1, t0, 0x00
        li   t2, 0xFF
        beq  t1, t2, test14
        j Fail_Xori_13

    test14:
        li   t0, 0x80
        xori t1, t0, 0x7F
        li   t2, 0xFF
        beq  t1, t2, test15
        j Fail_Xori_14

    test15:
        li   t0, 0x55
        xori t1, t0, 0x55
        li   t2, 0x00
        beq  t1, t2, test16
        j Fail_Xori_15

    test16:
        li   t0, 0x3C
        xori t1, t0, 0x3C
        li   t2, 0x00
        beq  t1, t2, test17
        j Fail_Xori_16

    test17:
        li   t0, 0x11
        xori t1, t0, 0x22
        li   t2, 0x33
        beq  t1, t2, test18
        j Fail_Xori_17

    test18:
        li   t0, 0x0F
        xori t1, t0, 0xF0
        li   t2, 0xFF
        beq  t1, t2, test19
        j Fail_Xori_18

    test19:
        li   t0, 0x69
        xori t1, t0, 0x69
        li   t2, 0x00
        beq  t1, t2, test20
        j Fail_Xori_19

    test20:
        li   t0, 0x7E
        xori t1, t0, 0x01
        li   t2, 0x7F
        beq  t1, t2, pass
        j Fail_Xori_20

    pass:
        j return_xori_test

Fail_Xori_1:
    li   gp, 561
    j    fail

Fail_Xori_2:
    li   gp, 562
    j    fail

Fail_Xori_3:
    li   gp, 563
    j    fail

Fail_Xori_4:
    li   gp, 564
    j    fail

Fail_Xori_5:
    li   gp, 565
    j    fail

Fail_Xori_6:
    li   gp, 566
    j    fail

Fail_Xori_7:
    li   gp, 567
    j    fail

Fail_Xori_8:
    li   gp, 568
    j    fail

Fail_Xori_9:
    li   gp, 569
    j    fail

Fail_Xori_10:
    li   gp, 570
    j    fail

Fail_Xori_11:
    li   gp, 571
    j    fail

Fail_Xori_12:
    li   gp, 572
    j    fail

Fail_Xori_13:
    li   gp, 573
    j    fail

Fail_Xori_14:
    li   gp, 574
    j    fail

Fail_Xori_15:
    li   gp, 575
    j    fail

Fail_Xori_16:
    li   gp, 576
    j    fail

Fail_Xori_17:
    li   gp, 577
    j    fail

Fail_Xori_18:
    li   gp, 578
    j    fail

Fail_Xori_19:
    li   gp, 579
    j    fail

Fail_Xori_20:
    li   gp, 580
    j    fail
