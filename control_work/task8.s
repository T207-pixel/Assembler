//Count difference beteen sum of arr and mul of arr
    .arch armv8-a
    .text
    .align  2
    .global _start
    .type   _start, %function
_start:
// x0 - length
// x15 - length
// sp - beginning of array
// x2 - sum
// x5 - #8
    mov     x0, #3
    
    mov     x1, #-7
    mov     x2, #3
    mov     x3, #-5
    mov     x4, #44
    mov     x5, #55
    mov     x6, #66
    mov     x7, #77
    mov     x8, #88
    mov     x9, #99
    mov     x10, #111

//___Start____//////////////////////////////
    mov     x15, x0
    stp     x2, x1, [sp, #-16]!
    stp     x4, x3, [sp, #-16]! 
    stp     x6, x5, [sp, #-16]!
    stp     x8, x7, [sp, #-16]! 
    stp     x10, x9, [sp, #-16]!
    add     sp, sp, #72
    mov     x2, #0              //Sum
    mov     x3, #1              //Mul
    mov     x7, #-1

Sum:
    cmp     x0, #0
    b.eq    ResSum
CountSum:
    ldr     x1, [sp], #-8
    add     x2, x2, x1
    sub     x0, x0, #1
    b       Sum
ResSum:
    mov     x0, x15
    mov     x5, #8
    mul     x4, x5, x0
    add     sp, sp, x4
Mul:
    cmp     x0, #0
    b.eq    Sign
CounMul:
    ldr     x1, [sp], #-8
    smull   x3, w3, w1
    sub     x0, x0, #1
    b       Mul
Sign:      
    cmp     x2, #0
    b.lt    1f
    b       2f
1:
    smull   x2, w2, w7
2:
    cmp     x3, #0
    b.lt    1f
    b       Delta
1:
    smull   x3, w3, w7
Delta:
    cmp     x2, x3
    b.ge    1f
    b       2f
1:
    sub     x0, x2, x3
2:
    sub     x0, x3, x2

