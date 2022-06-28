//min difference between first and second min
    .arch armv8-a
    .text
    .align  2
    .global _start
    .type   _start, %function
_start:
    mov     x0, #4

    mov     x1, #3
    mov     x2, #8
    mov     x3, #9
    mov     x4, #1
    mov     x5, #55
    mov     x6, #66
    mov     x7, #77
    mov     x8, #88
    mov     x9, #99
    mov     x10, #111
// x0 - arrSize
// x15 - x0 = const
// x1 - current
// x2 - min
// x3 - minDelta
// x4 - 
// x5 - 8 = const
// x6 - -1 = const
// x7 - secMin buf
// x8 - secMin
    mov     x15, x0
    stp     x2, x1, [sp, #-16]!
    stp     x4, x3, [sp, #-16]!
    stp     x6, x5, [sp, #-16]!
    stp     x8, x7, [sp, #-16]!
    stp     x10, x9, [sp, #-16]!
    add     sp, sp, #72
    mov     x2, #0              //min
    mov     x6, #-1
    mov     x7, #0              //buf
    
    ldr     x1, [sp]
    mov     x2, x1
Loop1:
    cmp     x0, #0
    b.eq       SecondMin
Min:
    ldr     x1, [sp], #-8
    cmp     x1, x2
    b.le    1f
    b       2f
1:
    mov     x2, x1
2:
    sub     x0, x0, #1
    b       Loop1
SecondMin:
    mov     x0, x15             //reestablish x0
    mov     x5, #8              //sizeof register
    mul     x4, x0, x4          // height of stack
    add     sp, sp, x4

    ldr     x1, [sp]
    sub     x1, x1, x2
    mov     x3, x1              // MinDelta
Loop2:
    cmp     x0, #0
    b       Sign
    mov     x7, x1              // secMin Buf
    ldr     x1, [sp], #-8
    sub     x1, x1, x2
    cmp     x1, x3
    b.le    1f
    b       2f
1:
    mov     x3, x1              //newDelta
    mov     x8, x7              // secMin
2:
    sub     x0, x0, #1
    b       Loop2
Sign:
    cmp     x2, #0
    b.lt    1f
    b       2f
1:
    smull   x2, w2, w6
2:
    cmp     x8, #0
    b.lt    1f
    b       Delta
1:
    smull   x8, w8, w6
Delta:
    cmp     x2, x8
    b.le    1f
    b       2f
1:
    sub     x0, x8, x2
2:
    sub     x0, x2, x8

    


