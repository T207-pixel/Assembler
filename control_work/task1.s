    .data
quantity:
    .byte   10
arr:
    .skip   5*8
    .text
    .align  2
    .global process
    .type   process, %function
process:
    //  x11 - number of elements 1-10
    //  x0  - max element
    //  x12 - address of array
    //  x13 - buf beginning of array
    //  x14 - 16 = const
    //  x15 - current number
    //  x16 - 0 = const
    //  x17 - counter 

    adr     x11, quantity
    ldrb    w11, [x11]
    mov     x0, #0
    adr     x12, arr
//---TESTING PARAMETERES---//
    mov     x1, #1
    mov     x2, #3
    mov     x3, #2
    mov     x4, #4
    mov     x5, #10
    mov     x6, #1
    mov     x7, #2
    mov     x8, #3
    mov     x9, #4
    mov     x10, #5
//-------------------------//
//---LOAD RARAMS---//    
    mov     x13, x12
    mov     x14, #16
    stp     x1, x2, [x13]
    add     x13, x13, x14
    stp     x3, x4, [x13]
    add     x13, x13, x14 
    stp     x5, x6, [x13]
    add     x13, x13, x14
    stp     x7, x8, [x13]
    add     x13, x13, x14
    stp     x9, x10, [x13]
    mov     x16, #8
    mov     x13, x12
    
    ldrb    w15, [x12]
    cmp     x0, x15
    b.le    0f
    b       1f
0:
    mov     x0, x15
    mov     x17, #1
1:
    cmp     x11, x17
    b.le    end
    add     x13, x13, x16
    ldrb    w15, [x13]
    add     x17, x17, #1
    cmp     x0, x15
    b.le    2f
    b       1b
2:
    mov     x0, x15
    b       1b

end:
    ret
    .size process, .-process
