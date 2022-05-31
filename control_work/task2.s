    .arch armv8-a
    .data
space:
    .ascii   " "
enter:
    .ascii   "\n"
    .text
    .align  2
    .global _start

    .type   _start, %function
_start:
    sub     sp, sp, #21
    // x3 - space
    // x2 - enter
    adr     x0, space
    ldrb    w3, [x0]
    adr     x0, enter
    ldrb    w2, [x0]
    str     x3, [x4]
//---READING FROM FILE---//
    mov     x0, #0
    mov     x1, sp
    mov     x2, #20
    mov     x8, #63
    svc     #0
//----------------------//
//---PRINT SYMBOLS---//
print:
    mov     x0, #1
    mov     x1, sp
    mov     x2, #1
    mov     x8, #64
    svc     #0
//----------------------//
0:
    add     sp, sp, #1
    ldrb    w4, [sp]
    cmp     w4, w3
    b.eq    1f
    cmp     w4, w2
    b.eq    1f
    b       0b
1:
    b       printSymbol
2:
    add     sp, sp, #1
    b       print
//---PRINT ' '---//
printSymbol:
    mov     x0, #1
    adr     x1, space
    mov     x2, #1
    mov     x8, #64
    svc     #0
    b       2b
exit:
    mov     x0, #0
    mov 	x8, #93
    svc 	#0
    .size _start, .-_start


