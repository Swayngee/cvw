// Minimal harness: run only sw_test (exercises sw + lw + branch)
// James Kaden Cassidy — used to isolate store-word vs full bringup

    .extern sw_test
    .extern pass

    .section .text.init
    .globl main
    .type  main, @function

main:
    j sw_test

    .globl return_sw_test
    .type  return_sw_test, @function
return_sw_test:
    j pass
