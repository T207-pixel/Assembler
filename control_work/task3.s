//Search and count max differences between two numbers from array
    .arch armv8-a
    .text
    .align  2
    .global _start
    .type   _start, %function
_start:
// x0 - length
// x15 - length
// sp - beginning of array
// x11 - sp start position
// x2 - max
// x3 - min
// x4 - const
// x5 - #8
// x6 - #-1
    mov     x0, #5
    mov     x15, x0
    mov     x1, #-11
    mov     x2, #22
    mov     x3, #33
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
    
//Algorythm//
//___MAX___//
    ldr     x1, [sp]
    mov     x2, x1
Loop1:
    cmp     x0, #0
    b.eq    3f
Max:
    ldr     x1, [sp], #-8
    cmp     x1, x2
    b.ge    1f
    b       2f
1:
    mov     x2, x1   
2:
    sub     x0, x0, #1
    b Loop1
//___MIN___//
3:
    mov     x0, x15
    mov     x5, #8
    mul     x4, x0, x5
    add     sp, sp, x4
    ldr     x1, [sp]
    mov     x3, x1
Loop2:
    cmp     x0, #0
    b.eq    Delta
Min:
    ldr     x1, [sp], #-8
    cmp     x1, x3
    b.le    1f
    b       2f
1:
    mov     x3, x1
2:
    sub     x0, x0, #1
    b       Loop2
//___Delta___//
Delta:
    mov     x6, #-1
    cmp     x2, #0
    b.lt    1f
    b       2f
1:
    smull   x2, w2, w6
2:
    cmp     x3, #0
    b.lt    1f
    b       2f
1:
    smull   x3, w3, w6
2:
    sub     x0, x2, x3
    
end:
    mov	    x0, #0
    mov	    x8, #93	
    svc	    #0
    .size	_start, .-_start
