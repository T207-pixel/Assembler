    .arch armv8-a
    .data
// ERROR messages
argumentsError:
    .string "Wrong quantity of arguments: " 
    .equ    argErrLen, .-argumentsError         // .equ == define, gives a symbolic name to a numeric constant . == current address, -argumentsError == - adreess of string
    // что делает .-
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
    adr     x1, argumentsError                  // address of buffer from where will go record
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
    sub     sp, sp, #24
    bl      process
end:
    mov     x0, #0
    mov     x8, #93
    svc     #0
    .size   _start, .-_start

    .type   process, %function
process:
    bl      openFile
    mov     x10, x0                             // fileDescriptor
    cmp     x0, #0
    b.le    1f
    b       2f
1:
    adr     x1, openErr
    mov     x2, openErrLen
    mov     x0, #2
    bl      write   // почему тут не сохраняется алрес возврата, если фу-ия вызывается в фу-ии
    mov     x0, #-2                                // wrong opening of file
    bl      end
2:
    bl      readText

    ret 
    .size   process, .-process
    
    .type   openFile, %function
openFile:
    mov     x0, #-100
    mov     x2, #0
    mov     x8, #56
    svc     #0
    ret
    .size   openFile, .-openFile

    .type   readText, %function
readText:
    mov     x5, #1                                  // flag = 1 in the beginning (flag if first symbol)
    mov     x6, #1                                  // flag = 1 in the beginning (flag to get first sym)
    str     x30, [sp, #8]
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
    //b.eq    2f
    b.eq    18f
    b       17f
17:
    mov     x1, x11//new                            // put address for writing on the start point
11:    
    cmp     x14, #0                                  // if EOF
    b.eq    3f
    b       1b
/////////////////////// reading last symbol (smth wrong)
18:
    sub     x1, x1, #1
    mov     x0, x10                                 // fileDescriptor          
    mov     x8, #63                                 // reading
    svc     #0
    ldrb    w13, [x1]
    cmp     w13, #0
    b.eq    end
    add     x1, x1, #1
    mov     x0, x10
    b       2f
///////////////////////
2:
    sub     x2, x22, x1
    str     x30, [sp, #8]!
    bl      writeRev
    mov     x1, x11//new                            // put address for writing on the start point
    ldr     x30, [sp], #-8
    mov     x5, #0
    b       0b
3:
    mov     x0, x10
    mov     x8, #57
    svc     #0
    b       end
    ret
    .size   readText, .-readText
    
    .type   write, %function
write:
    mov     x0, #2
    mov     x8, #64
    svc     #0
    ret
    .size   write, .-write

    .type   writeRev, %function
writeRev:
    mov     x4, x1
    sub     x4, x1, #1
    mov     x1, x22
1:
    cmp     x1, x4
    b.eq    2f
    str     x30, [sp, #8]!
    str     x2, [sp, #8]!
    bl      writeSymbol
    ldr     x2, [sp], #-8
    ldr     x30, [sp], #-8
    sub     x1, x1, #1
    b       1b
2:
    ret
    .size   writeRev, .-writeRev

    .type   writeSymbol, %function
writeSymbol:
    mov     x0, #2                                  // file descriptor for printing
    mov     x2, #1
    mov     x8, #64
    svc     #0
    ret
    .size   writeSymbol, .-writeSymbol  