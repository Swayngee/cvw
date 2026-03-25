// Branch Not Equal Test
// C Runtime entry point

.extern return_bne_test
.extern fail

.section .text.init
.globl bne_test
.type  bne_test, @function

bne_test:
    test1:
        li   t0, 5
        li   t1, 10
        bne  t0, t1, test2   # should branch (5 != 10)
        j    Fail_Bne_1

    test2:
        li   t0, 7
        li   t1, 7
        bne  t0, t1, Fail_Bne_2  # should NOT branch (7 == 7)
        j    test3

    test3:
        li   t0, 0
        li   t1, 1
        bne  t0, t1, test4   # should branch (0 != 1)
        j    Fail_Bne_3

    test4:
        li   t0, 0
        li   t1, 0
        bne  t0, t1, Fail_Bne_4  # should NOT branch (0 == 0)
        j    test5

    test5:
        li   t0, -1
        li   t1, 1
        bne  t0, t1, test6   # should branch (-1 != 1)
        j    Fail_Bne_5

    test6:
        li   t0, -5
        li   t1, -5
        bne  t0, t1, Fail_Bne_6  # should NOT branch (-5 == -5)
        j    test7

    test7:
        li   t0, -1
        li   t1, 0
        bne  t0, t1, test8   # should branch (-1 != 0)
        j    Fail_Bne_7

    test8:
        li   t0, 100
        li   t1, 100
        bne  t0, t1, Fail_Bne_8  # should NOT branch (100 == 100)
        j    test9

    test9:
        li   t0, 0x7FFFFFFF
        li   t1, 0
        bne  t0, t1, test10  # should branch (MAX_INT != 0)
        j    Fail_Bne_9

    test10:
        li   t0, 0x7FFFFFFF
        li   t1, 0x7FFFFFFF
        bne  t0, t1, Fail_Bne_10 # should NOT branch (MAX_INT == MAX_INT)
        j    test11

    test11:
        li   t0, 1
        li   t1, -1
        bne  t0, t1, test12  # should branch (1 != -1)
        j    Fail_Bne_11

    test12:
        li   t0, -100
        li   t1, -100
        bne  t0, t1, Fail_Bne_12 # should NOT branch (-100 == -100)
        j    test13

    test13:
        li   t0, 0xFF
        li   t1, 0x0F
        bne  t0, t1, test14  # should branch (0xFF != 0x0F)
        j    Fail_Bne_13

    test14:
        li   t0, 0xAB
        li   t1, 0xAB
        bne  t0, t1, Fail_Bne_14 # should NOT branch (0xAB == 0xAB)
        j    test15

    test15:
        li   t0, 0
        li   t1, -0
        bne  t0, t1, Fail_Bne_15 # should NOT branch (0 == -0)
        j    test16

    test16:
        li   t0, 2
        li   t1, 3
        bne  t0, t1, test17  # should branch (2 != 3)
        j    Fail_Bne_16

    test17:
        li   t0, 0x80000000
        li   t1, 0x7FFFFFFF
        bne  t0, t1, test18  # should branch (MIN_INT != MAX_INT)
        j    Fail_Bne_17

    test18:
        li   t0, 0x80000000
        li   t1, 0x80000000
        bne  t0, t1, Fail_Bne_18 # should NOT branch (MIN_INT == MIN_INT)
        j    test19

    test19:
        li   t0, 42
        li   t1, 43
        bne  t0, t1, test20  # should branch (42 != 43)
        j    Fail_Bne_19

    test20:
        li   t0, 0x55
        li   t1, 0x55
        bne  t0, t1, Fail_Bne_20 # should NOT branch (0x55 == 0x55)
        j    pass

    pass:
        j return_bne_test

Fail_Bne_1:
    li   gp, 261
    j    fail

Fail_Bne_2:
    li   gp, 262
    j    fail

Fail_Bne_3:
    li   gp, 263
    j    fail

Fail_Bne_4:
    li   gp, 264
    j    fail

Fail_Bne_5:
    li   gp, 265
    j    fail

Fail_Bne_6:
    li   gp, 266
    j    fail

Fail_Bne_7:
    li   gp, 267
    j    fail

Fail_Bne_8:
    li   gp, 268
    j    fail

Fail_Bne_9:
    li   gp, 269
    j    fail

Fail_Bne_10:
    li   gp, 270
    j    fail

Fail_Bne_11:
    li   gp, 271
    j    fail

Fail_Bne_12:
    li   gp, 272
    j    fail

Fail_Bne_13:
    li   gp, 273
    j    fail

Fail_Bne_14:
    li   gp, 274
    j    fail

Fail_Bne_15:
    li   gp, 275
    j    fail

Fail_Bne_16:
    li   gp, 276
    j    fail

Fail_Bne_17:
    li   gp, 277
    j    fail

Fail_Bne_18:
    li   gp, 278
    j    fail

Fail_Bne_19:
    li   gp, 279
    j    fail

Fail_Bne_20:
    li   gp, 280
    j    fail
