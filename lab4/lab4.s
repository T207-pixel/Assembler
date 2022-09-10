    .arch   armv8-a 
    .data
    .align  2               //тк работаю с float (выравнивание на самый большой тип данных)

inpEnterX:
    .string "Enter x: "
inpFormat:
    .string "%f"            // for scanf
libValue:
    .string "[LIB]: cos(x) = %.10lf\n"// printf работает только с lf -> double
inEnterAcc:
    .string "Enter accurancy: "
myValue:
    .string "[MY]: cos(x) = %.10lf\n"

myCosValue:
    .float  1               //variable
iterator:
    .float  1               //variable
const1:
    .float  1
const2:
    .float  2    
const4:
    .float  4
constPi2:
    .float  9.869600        // (pi)^2, 6-7 знаков для одинарной точности всего (будет в вопросе от храпа)

    .text
    .align  2
    .global main
    .type   main, %function
    .equ    x, 16           //place for x -> scanf
    .equ    y, 24           //place for libValue
main:
    stp     x29, x30, [sp, -32]!//because x29 and x30 will be changed after call of new func
    mov     x29, sp

//INPUT------------------------------------------------
    adr     x0, inpEnterX   // x0 (string) - first param in printf is, second param may be d0 (float)
    bl      printf
    adr     x0, inpFormat   //x0 - specificator for scanf (%f == float)
    add     x1, x29, x      //x1 - address where realValue will be saved
    bl      scanf
//-----------------------------------------------------

//LIB VALUE OUT----------------------------------------
    ldr     s0, [x29, x]    //load in d0 entered x(radians) value
    fcvt    d0, s0          //convert in double for print
    bl      cos             //calculating
    fcvt    s0, d0
    fmov    s9, s0          //realCos value

    str     s9, [x29, y]    //store in address (y) realCos value
    
    adr     x0, libValue    
    ldr     s0, [x29, y]
    fcvt    d0, s0
    bl      printf          // first argument is x0, seconf is d0
    fcvt    s0, d0          //convert from double back to float
//-----------------------------------------------------

//MY VALUE OUT-----------------------------------------
    ldr     s0, [x29, x]
    bl      myCos           //convertation is needn't because math.h is not used here
    str     s0, [x29, y]

    adr     x0, myValue
//-----------------------------------------------------
    ldp     x29, x30, [sp], 32
    ret
    .size   main, .-main

//MY COS FUNCTION
    .type   myCos, %function
    .equ    accuracy, 16
    .equ    myCosStack, 20   //res value
    .equ    iteratorStack, 24
    .equ    x, 28
    .equ    mathCos, 32
myCos:
/*
    s0 - input
    s0 - output
 */
    stp     x29, x30, [sp, -40]!
    mov     x29, sp
    str     s0, [x29, x]        //saved x(radian in stack)
    str     s9, [x29, mathCos]  //saved realCos value in stack

//ENTER ACCURACY---------------------------------------
    adr     x0, inEnterAcc
    bl      printf
    adr     x0, inpFormat
    add     x1, x29, accuracy
    bl      scanf
    ldr     s1, [x29, accuracy]
//-----------------------------------------------------

//INITIALISE DATA AND FILL STACK WITH PARAMS-----------
    adr     x0, myCosValue
    ldr     s2, [x0]
    str     s2, [x29, myCosStack]
    adr     x0, const1
    ldr     s3, [x0]
    adr     x0, const2
    ldr     s4, [x0]
    adr     x0, const4
    ldr     s5, [x0]
    adr     x0, constPi2
    ldr     s6, [x0]
    adr     x0, iterator
    ldr     s7, [x0]
    str     s7, [x29, iteratorStack]
    mov     w8, #0
    scvtf   s8, w8
    ldr     s0, [x29, x]
//-----------------------------------------------------

//Initialised
/*
    s0 - x(radian)
    s1 - accuracy
    s2 - myCos(res) = 1
    s3 - const = 1
    s4 - const = 2
    s5 - const = 4
    s6 - const = Pi^2
    s7 - iterator = 1
    s8 - current = 0
    s9 - mathCos value
*/
//While calculating
/*
    s0 - 4x^2
    s10 - realCos - myCos
    s11 - buf
    s12 - buf
 */
 
//ALGORITHM OF COUNTING ACCURANCY
    fmul    s0, s0, s0          //pow(x,2)
    //str     s0, [x29, -4]
    fmul    s0, s5, s0          //4*pow(x,2)
    //str     s0, [x29, -4]
Loop:  
    fsub    s10, s9, s2         //realCos - myCos
    //str     s10, [x29, -4]
    fabs    s10, s10            //|s10|
    //str     s10, [x29, -4] 
    fcmp    s10, s1             //(realCos - myCos) > accuracy)
    b.gt    go 
    b       stop
go:
//COUNTING MEMBER
    fmul    s11, s4, s7         //2*i
    //str     s11, [x29, -4]
    fsub    s11, s11, s3        //2*i-1
    //str     s11, [x29, -4]
    fmul    s11, s11, s11       //pow((2*i-1),2)
    //str     s11, [x29, -4]
    fmul    s11, s11, s6        //(pow((2*i-1),2)*pow(Pi,2))
    //str     s11, [x29, -4]
    fdiv    s11, s0, s11        //(4*pow(x,2))/(pow((2*i-1),2)*pow(Pi,2))
    //str     s11, [x29, -4]
    fsub    s12, s3, s11        //current
    //str     s12, [x29, -4]
    fmov    s8, s12             //current
    //str     s8, [x29, -4]
//SERIES MULTIPLICATION
    fmul    s11, s2, s8         //myCos * current;
    //str     s11, [x29, -4]
    fmov    s2, s11             //s2 - myCos
    //str     s2, [x29, -4]
    fadd    s7, s7, s3          //i++
    //str     s7, [x29, -4]
    b       Loop
stop:
    str     s2, [x29, myCosStack]//store myCos in stack
    adr     x0, myValue    
    ldr     s2, [x29, myCosStack]
    fcvt    d0, s2
    bl      printf              // first argument is x0, seconf is d0
//-----------------------------------------------------

    ldp     x29, x30, [sp], 40
    ret
    .size   myCos, .-myCos
