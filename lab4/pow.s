    .arch   armv8-a 
    .data
    .align  1
base:
    .float  99
//ARGUMENTS
//s1 - base
//s1 -> res form here

//LOCAL VARS
//s2 - myExp
//s3 - res (buf)
//s4 - counter
//s5 - i
//s6 - 1 = const

    .text
    .align  2
    .global main
    .type   main, %function
main:
    adr     x0, base
    ldr     s1, [x0]
    mov     w2, #2
//INTEGER VALUE FOR CONVERTATION
    mov     w3, #1
    mov     w4, #0
//CONVERTATION
    scvtf   s2, w2
    scvtf   s3, w3
    scvtf   s4, w4
    scvtf   s5, w4
    scvtf   s6, w3
Loop:
    fcmp    s5, s2
    b.ge    End
    fadd    s5, s5, s6
    fcmp    s4, s2
    b.ne    Count
    b.eq    Loop
    b       End
Count:
    fadd    s4, s4, s6
    fmul    s3, s3, s1
    b       Loop
End:
    fmov    s1, s3

    mov     x0, #0
    mov     x8, #93
    svc     #0
    .size   main, .-main