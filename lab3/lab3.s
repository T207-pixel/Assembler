    .arch armv8-a
    .data
// ERROR messages
argumentsError:
    .string "Wrong quantity of arguments: " 
    .equ    argErrLen, .-argumentsError         // .equ == define, gives a symbolic name to a numeric constant . == current address, -argumentsError == - adreess of label
errMessage1:
    .string " filename\n"                      
    .equ    fileErrLen, .-errMessage1  
openErr:
    .string "Could not open file!\n"            
    .equ    openErrLen, .-openErr
// specific symbols
space:
    .ascii  " "  // x20
enter:
    .ascii "\n" // x21
//.__________________.
//|----***Data***----|
//| x20 - space      |
//| x21 - enter      |
//| x23 - firstSym   |
//| x10 - fileDescriptor
//|__________________|
    .text
    .align  2
    .global _start
    
    .type   _start, %function
_start:
    adr     x20, space
    ldrb    w20, [x20]
    adr     x21, enter
    ldrb    w21, [x21]
    ldr     x0, [sp]                            // quantity of parameters
    cmp     x0, #2                              // progName & filename, checking for incorrect input of arguments
    b.eq    2f
    adr     x1, argumentsError                  // address of first symbol
    mov     x2, argErrLen                       // size of buffer
    bl      write
    ldr     x1, [sp, #8]                        // here is name of program
    mov     x2, #0
0:
    ldrb    w3, [x1, x2]                        // readfilename
    cbz     w3, 1f                              // if last symbol is zero
    add     x2, x2, #1
    b       0b 
1:
    bl      write
    adr     x1, errMessage1
    mov     x2, fileErrLen
    bl      write
    mov     x0, #-1                             // wrong quantitu of parameters code
    b      end
2:
    ldr     x1, [sp, #16]                       // text.file
    bl      process
end:
    mov     x0, #0
    mov     x8, #93
    svc     #0
    .size   _start, .-_start

    .type   process, %function
process:
    str     x30, [sp, #-8]!                    //кадр стека сфорирован внутри процедуры (по соглашению вызовов)
    mov     x29, sp
    bl      openFile
    mov     x10, x0                             // fileDescriptor
    cmp     x0, #0
    b.le    1f
    b       2f
1:
    adr     x1, openErr
    mov     x2, openErrLen
    mov     x0, #2
    bl      write   
    mov     x0, #-2                                // wrong opening of file
    bl      end
2:
    bl      readText
    ldr     x30, [sp], #8
    ret 
    .size   process, .-process
    
    .type   openFile, %function
openFile:
    mov     x0, #-100                               // (path descriptor)current directory (-100) nay other number is other direcory
    mov     x2, #0                                  // priority of access 0 -read, 1 - write, 2 - read and write, possible to put two many flags
    mov     x8, #56                                 // number of sys call
    svc     #0                                      // supervisor
    ret
    .size   openFile, .-openFile

    .type   readText, %function
readText:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp
    mov     x24, #1
    mov     x5, #1                                  // flag = 1 in the beginning (flag if first symbol)
    mov     x6, #1                                  // flag = 1 in the beginning (flag to get first sym)
    //////////////
    sub     sp, sp, #1
    mov     x25, #9
    str     x25, [sp]
    mov     x26, [sp]                               // address of local variable
    //////////////
    sub     sp, sp, #1
    mov     x1, sp
    mov     x11, sp                                 //new// start position of stack writing always here
0:                               
    mov     x2, #1                                  // buf size
    mov     sp, x11                                 //new// make sp stay in the start position
    mov     x22, sp
1:
    sub     x1, x1, #1
    mov     x0, x10                                 // fileDescriptor          
    mov     x8, #63                                 // reading
    svc     #0

    cbnz    x0, 555f
    mov     x24, #0
555:  

    mov     x14, x0                                 // quantity of symbols after reading
    mov     x0, x10

    cmp     x6, #1                                  // get first sym only once
    b.eq    4f
    b       5f
4:
    mov     x23, x1
    ldrb    w23, [x23]
    mov     x6, #0
5:
    ldrb    w3, [x1]
    cmp     x3, x23                                 // if current_sym == first_sym
    b.eq    6f
    b       7f
6:
    cmp     x5, #1
    b.eq    7f
    b       12f
12:
    add     x1, x1, #1
    ldrb    w7, [x1]
    cmp     x7, #0
    b.eq    15f
    b       7f
15:
    mov     x22, x1
    mov     x5, #1
    sub     x1, x1, #1
    b       7f
    ///////////////////
13:
    mov     x22, x1
    mov     x5, #1
    sub     x1, x1, #1
    b       7f
14:
    mov     x22, x1
    mov     x5, #1
    sub     x1, x1, #1
    b       7f
7:
    cmp     x3, x20                                 // if ' '
    b.eq    8f                                      // &&
    b       9f
8:
    mov     x12, x3                                 // save register befor cleaninh stack//new
    cmp     x5, #1                                  // first_sym correct
    b.eq    2f
    b       16f                                     // put address for writing on the start point
16:
    mov     x1, x11//new
9:    
    cmp     x3, x21                                 // if '\n'
    b.eq    10f                                     // &&
    b       11f
10:
    mov     x12, x3                                 // save register befor cleaninh stack//new
    cmp     x5, #1                                  // first_sym correct    
    b.eq    18f
    b       17f
17:
    mov     x1, x11                                 // put address for writing on the start point
    mov     x14, x1
    b       printSpecial
//////////////////////////////////
printSpecial:
    mov     x0, #1
    adr     x1, enter
    mov     x2, #1
    mov     x8, #64
    svc     #0
    mov     x0, x10
    mov     x1,x14
    b       11f
/////////////////////////////
11:    
    cmp     x24, #0                                  // if EOF
    b.eq    3f
    b       1b
/////////////////////// reading last symbol (smth wrong)
18:
    //sub     x1, x1, #1//old
    add     x1, x1, #1//new
    mov     x0, x10                                 // fileDescriptor          
    mov     x8, #63                                 // reading
    svc     #0
    ldrb    w13, [x1]
    cmp     w13, #0
    //b.eq    end
    b.eq    666f
    sub     x1, x1, #1//new
    //add     x1, x1, #1//old
    mov     x0, x10
    b       2f
///////////////////////
2:
    sub     x2, x22, x1
    mov     sp, x1
    bl      writeRev
    mov     x1, x11//new                            // put address for writing on the start point
    mov     x5, #0
    b       0b
3:
    mov     x0, x10
    mov     x8, #57
    svc     #0
    add     sp, x29, #16
    ldp     x29, x30, [x29]
666:
    ret
    .size   readText, .-readText
    
    .type   write, %function
write:
    mov     x0, #2                                                  // 2 - standart stream of mistakes
    mov     x8, #64
    svc     #0
    ret
    .size   write, .-write

    .type   writeRev, %function
writeRev:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp
    mov     x4, x1
    sub     x4, x1, #1
    mov     x1, x22
1:
    cmp     x1, x4
    b.eq    2f
    bl      writeSymbol
    sub     x1, x1, #1
    b       1b
2:
    ldp     x29, x30, [x29]
    ret
    .size   writeRev, .-writeRev

    .type   writeSymbol, %function
writeSymbol:
    mov     x0, #1                                  // filedescriptor 1 - for output
    mov     x2, #1                                  // size of bufer
    mov     x8, #64
    svc     #0
    ret
    .size   writeSymbol, .-writeSymbol  