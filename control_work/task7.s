// Find max even number in array
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
// x5 -
// x6 - 2 = const
    mov     x0, #3
    mov     x15, x0
    mov     x1, #-4
    mov     x2, #5
    mov     x3, #-8
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
//___MaxEven number___//
    ldr     x1, [sp]
    mov     x2, x1
Loop1:
    cmp     x0, #0
    b.eq    Res
Max:
    mov     x6, #2
    ldr     x1, [sp], #-8
//___Even?___??
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
Res:
    mov     x0, x2

end:
    mov	    x0, #0
	mov	    x8, #93
	svc	    #0
	.size	_start, .-_start

