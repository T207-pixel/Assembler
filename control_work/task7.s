// Find max even number in array (ResMax)
// Find min odd in array (ResMin)
    .arch armv8-a
    .text
    .align  2
    .global _start
    .type   _start, %function
_start:
// x0 - length
// x15 - length
// sp - beginning of array
// x1 - current
// x2 - max
// x3 - diveded res (for compare)
// x4 - mul res (for compare)
// x5 - save x0
// x6 - 2 = const
// x7 - min
// x8 -
// x9 -
    mov     x0, #3
    mov     x15, x0
    mov     x1, #-4
    mov     x2, #5
    mov     x3, #-9
    mov     x4, #44
    mov     x5, #55
    mov     x6, #66
    mov     x7, #77
    mov     x8, #88
    mov     x9, #99
    mov     x10, #111
//___Start____//////////////////////////////
    stp     x2, x1, [sp, #-16]!
    stp     x4, x3, [sp, #-16]!
    stp     x6, x5, [sp, #-16]!
    stp     x8, x7, [sp, #-16]!
    stp     x10, x9, [sp, #-16]!
    add     sp, sp, #72
//___MaxEven___//
    ldr     x1, [sp]
    mov     x2, x1              //max
Loop1:
    cmp     x0, #0
    b.eq    ResMax
Max:
    mov     x6, #2
    ldr     x1, [sp], #-8
//___Even?___//
    sdiv    x3, x1, x6
    smull   x4, w3, w6
    cmp     x1, x4
    b.eq    0f
    b       2f
0:
    cmp     x1, x2
    b.ge    1f
    b       2f
1:
    mov     x2, x1
2:
    sub     x0, x0, #1
    b       Loop1
ResMax:
    mov     x0, x2
//____MinOdd___//
    mov     x0, x15
    mov     x5, #8
    mul     x4, x0, x5
    add     sp, sp, x4

    ldr     x1, [sp]
    mov     x7, x1              //min
Loop2:
    cmp     x0, #0
    b.eq       ResMin
Min:
    mov     x6, #2
    ldr     x1, [sp], #-8
//___Odd?___//
    sdiv    x3, x1, x6
    smull   x4, w3, w6
    cmp     x1, x4
    b.ne    0f
    b       2f
0:
    cmp     x1, x7
    b.le    1f
    b       2f
1:
    mov     x7, x1
2:
    sub     x0, x0, #1
    b       Loop2
ResMin:
    mov     x3, x7


end:
    mov	    x0, #0
	mov	    x8, #93
	svc	    #0
	.size	_start, .-_start

