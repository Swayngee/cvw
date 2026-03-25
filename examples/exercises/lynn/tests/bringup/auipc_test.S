// Add Upper Immediate to PC Test
// C Runtime entry point

.extern return_auipc_test
.extern fail

.section .text.init
.globl auipc_test
.type  auipc_test, @function

auipc_test:
    test1:
        auipc t0, 0          # t0 = PC + 0 (PC of this instruction)
        auipc t1, 0          # t1 = PC + 0 (PC of this instruction, 4 bytes later)
        addi  t2, t0, 4      # t0 + 4 should equal t1
        beq   t2, t1, test2
        j     Fail_Auipc_1

    test2:
        auipc t0, 1          # t0 = PC + 0x1000
        auipc t1, 0          # t1 = current PC
        addi  t2, t1, 4      # next PC
        # t0 should be t1 - 4 + 0x1000
        li    t3, 0x1000
        sub   t4, t0, t3     # t4 = t0 - 0x1000 = PC of auipc t0,1
        addi  t5, t4, 4      # next instr after that
        beq   t5, t1, pass   # should match auipc t1,0 address
        j     Fail_Auipc_2

    pass:
        j return_auipc_test

Fail_Auipc_1:
    li   gp, 331
    j    fail

Fail_Auipc_2:
    li   gp, 332
    j    fail
