    .arch   armv8-a
    .data
mes:
    .string "%lf \n"
    .text
    .align  2
    .global imageProcAsm
    .type   imageProcAsm, %function

//ARGS
// x0 - data
// x1 - newData
// w2 - x
// w3 - y
// d0 - angle

// d1 - angle
// x4 - i
// d4 - i(double)
// x5 - j
// d5 - j(double)
// x6 - k
// x7 - ind1
// d2 - cos(angle)
// d3 - sin(angle)
// x8 - newX
// x9 - newY
// x10 - ind2
// x11 - 0 = const
// x12 - 3 = const
// d6 - buf
// d7 - buf
// d8 - buf
// x13 - buf
// x13 - buf
// x14 - buf
// x15 - current pixel

imageProcAsm:
    stp     x29, x30, [sp, #-16]!
    mov     x11, #0     // 0 = const
    mov     x12, #3     // 3 = const
    mov     x4, #0      // i = 0
LoopI:                  // for (int i = 0; i < x; i++)
    cmp     x4, x2
    b.ge    End
    mov     x5, #0      // j = 0
LoopJ:                  // for (int j = 0; j < y; j++)
    cmp     x5, x3
    b.ge    nextI
    //Counting ind1
    mul     x13, x5, x2 // j*x
    add     x13, x13, x4// j*x + i
    mul     x7, x12, x13// 3*(j*x + i)
    //Preparing params for counting newX and newY
    str     d0, [sp, #-8]!
    stp     x1, x0, [sp, #-16]!
    stp     x3, x2, [sp, #-16]!
    stp     x5, x4, [sp, #-16]!
    bl      cos
    str     d0, [sp, #-8]!  // cos
    ldr     d0, [sp, #56]   // angle (old)
    bl      sin
    str     d0, [sp, #-8]!  // sin
    ldr     d3, [sp], #8    // sin
    ldr     d2, [sp], #8    // cos
    ldp     x5, x4, [sp], #16
    ldp     x3, x2, [sp], #16
    ldp     x1, x0, [sp], #16
    ldr     d0, [sp], #8
    scvtf   d4, x4
    scvtf   d5, x5
    //Counting newX
    fmul    d6, d4, d2  // i * cos(angle)
    fmul    d7, d5, d3  // j * sin(angle)
    fsub    d8, d6, d7  // newX(double)
    fcvtns  x8, d8      // newX(int)
    //Counting newY
    fmul    d6, d4, d3  // i * sin(angle)
    fmul    d7, d5, d2  // j * cos(angle)
    fadd    d9, d6, d7  // newY(double)
    fcvtns  x9, d9      // newY(int)

    //fcvtns  x5, d5
    //fcvtns  x4, d4

    cmp     x8, #0
    b.lt    nextJ
    cmp     x9, #0
    b.lt    nextJ
    //Counting ind2
    mul     x13, x9, x2 // newY * x
    add     x13, x13, x8// newY * x + newX
    mul     x10, x12, x13// 3 * (newY * x + newX)
    //Check (ind2 >= x * y * 3)
    mul     x13, x2, x3
    mul     x13, x13, x12
    cmp     x10, x13
    b.ge    nextJ
    mov     x6, #0        // k = 0
LoopK:
    cmp     x6, #3
    b.ge    nextJ
    add     x13, x10, x6  // ind2 + k
    add     x14, x7, x6   // ind1 + k
    ldrb    w15, [x0, x13]// data[ind2 + k]     //was str
    strb    w15, [x1, x14]// newData[ind1 + k]  //was ldr
    add     x6, x6, #1    // k++
    b       LoopK
nextJ:
    add     x5, x5, #1    // j++
    b       LoopJ
nextI:
    add     x4, x4, #1    // i++
    b       LoopI
End:
    ldp     x29, x30, [sp], #16
    ret
    .size   imageProcAsm, .-imageProcAsm
