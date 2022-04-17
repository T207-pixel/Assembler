    .arch armv8-a
//Main
 ///***Data***///
    .data
    .align  1
size:
    .2byte  20
matrix:
    .2byte  1, 2, 3, 4, 5
    .2byte  9, 8, 7, 6, 5
    .2byte  1, 2, 1, 4, 5
    .2byte  1, 2, 3, 4, 5
resArr:
    .skip   10          // n * size(byte)
length:
    .2byte  5
hight:
    .2byte  4
    .text
    .align  2
    .global _start
    .type   _start, %function
_start:

///***Variables and local parametrs cheat sheet***///
//          x0 = address of matrix                 //
//          x1 = hight = 4                         //
//          x2 = length = 5                        //
//          x3 = size = 20                         // 
//          x4 = address of array which contains max elements
/////////////////////////////////////////////////////

///***Load Parametrs***///
    adr     x0, hight
    ldrsh   x1, [x0]        // x1 = hight = 4
    adr     x0, length
    ldrsh   x2, [x0]        // x2 = length = 5
    adr     x0, size
    ldrsh   x3, [x0]        // x3 = size = 20
    adr     x0, matrix      // x0 = address of matrix
    adr     x4, resArr      // x4 = address of array which contains max elements

///***Function Main***///
    str     x3, [sp, #-8]!  // save x3 = size = 20
    str     x4, [sp, #-8]!  // save x4
    mov     x3, x4
    bl      maxElements     // parametrs x0, x4, x2, x1
    ldr     x4, [sp], #8    // load previous parametrs
    ldr     x3, [sp], #8    // load previous parametrs
    bl      insertSortBinarySearch// parametrs x4, x0, x2, x3
    mov	x0, #0
	mov	x8, #93
	svc	#0
	.size	_start, .-_start

///***Function maxElements***///    
    .type   maxElements, %function
maxElements:
// x0 = matrix address
// x1 = hight
// x2 = length
// x3 = resMatrix address
    ///***Algoritm***///
// tmp variables: x4, x5, x6, x7, x8
    mov     x4, #0              // x4 = j = 0
///***While (j < length)***///
L0:
    cmp     x4, x2              // if (j < length)
    b.ge    L2                  // End of external cycle
    ldrsh   x5, [x0, x4, lsl #1]// x5 = max = *(arr + j) (value)
    mov     x6, x4              // x6 = i
L1:
///***While (i < j + length*(hight - 1))***///
    mov     x7, #1              // x7 = 1
    sub     x7, x1, x7          // hight - 1
    mul     x7, x7, x2          // length*(hight - 1)
    add     x7, x4, x7          // j + length*(hight - 1)
    cmp     x6, x7              // if (i < j + length*(hight - 1))
    b.ge    L3                  // go to resArr[j] = max;
    ldrsh   x8, [x0, x6, lsl #1]// *(arr + i)
    cmp     x5, x8              // if (max < *(arr + i))
    b.lt    L4                  // go to max = *(arr + i) (lt == <)
    add     x6, x6, x2          // i += length
    b       L1
L4:
    mov     x5, x8              //  max = *(arr + i);
    add     x6, x6, x2          // i += length
    b       L1
L3:
    strh    w5, [x3, x4, lsl #1]// resArr[j] = max 
    add     x4, x4, #1
    b       L0
L2:
    mov     x5, #0
    mov     x6, #0
    mov     x7, #0
    mov     x8, #0
    ret
    .size   maxElements, .-maxElements

///***Function insertSortBinarySearch***///
    .type   insertSortBinarySearch, %function
insertSortBinarySearch:
///***Algoritm***///
    mov     x7, #1          // x7 = i = 1
///***for (int i = 1; i < length; i++)***/    
    str     x30, [sp, #-8]!  // saved ret to 51th line
 0:
    cmp     x7, x2          // (i < length)
    b.ge    5f              // End of cycle     
    sub     x8, x7, #1      // x8  = j = i - 1
    ldrsh   x9, [x4, x7, lsl #1]// arrMax[i]
    ldrsh   x10, [x4, x8, lsl #1]// arrMax[j]
    cmp     x9, x10         // if (arrMax[i] < arrMax[j])
    b.ge    1f              // go to 1
    b.lt    6f              // go to 6
1:
    add     x7, x7, #1      // i++
    b       0b              // go to 0
6:
    mov     x11, #0         // x11 = k = 0
    mov     x13, #0         // x13 = left = 0
///***Prepare parametrs for function***///    
    stp     x1, x2, [sp, #-16]!   // save value of x2
    str     x3, [sp, #-8]!
    stp     x4, x5, [sp, #-16]!  // save value of x4, x5 before changing it in func binarySearch
    stp     x6, x7, [sp, #-16]!// same
    str     x8,  [sp, #-8]!// same
    mov     x5, x4          // x5 = x4 = arrMax
    mov     x2, x13         // x2 = x13 = left 
    mov     x1, x8          // x1 = x8 = right
    mov     x3, x9          // x3 = x9 = key
    bl      binarySearch    // parametrs x4, x13, x8, x9 // save res in x11
    ldr     x8, [sp], #8//same
    ldp     x6, x7, [sp], #16//same 
    ldp     x4, x5, [sp], #16//previous value
    ldr     x3, [sp], #8
    ldp     x1, x2, [sp], #16// previous value
///***for (int m = j; m > k; --m)***///
    mov     x11, x9         // x11 = key
    mov     x12, x8         // x12 = m
4:         
    cmp     x12, x11        //  m > k
    b.le    8f
    b.gt    7f
7:
    //NEW
    cmp     x9, x10         // (arrMax[i] < arrMax[j])
    b.ge    9f
//b.lt

    ldrsh   x14, [x4, x12, lsl #1]// x14 = arrMax[m]
    add     x15, x12, #1       // x15 = m +1
    ldrsh   x16, [x4, x15, lsl #1]// x16 = arrMax[m + 1]
///***Swap max elements***///
    strh    w14, [x4, x15, lsl #1]// store value of in address 
    strh    w16, [x4, x12, lsl #1]// store value of in address
///***swapColumnsArithmetic***///    
///***Prepare parametrs for function***///
    stp     x0, x1, [sp, #-16]!        //save parametrs before func
    stp     x2, x3, [sp, #-16]!
    stp     x4, x5, [sp, #-16]!
    stp     x6, x7, [sp, #-16]!
    stp     x8, x9, [sp, #-16]!
    mov     x9, x1          // hight
    mov     x1, x12         // first index
    mov     x3, x15         // second index
    mov     x4, x2          // length of string
    bl      swapColumns         // parametrs x0, x12, x15, x3
    ldp     x8, x9, [sp], #16
    ldp     x6, x7, [sp], #16
    ldp     x4, x5, [sp], #16
    ldp     x2, x3, [sp], #16
    ldp     x0, x1, [sp], #16

    sub     x7, x7, #1        // i--
    sub     x8, x8, #1        // j--
    sub     x12, x12, #1      // m--
    b       4b
8:

    add     x7, x7, #1        // i++
    b       0b
9:
    sub     x12, x12, #1      // m--
    b       4b
5:    
    ldr     x30, [sp], #8
    ret
    .size   insertSortBinarySearch, .-insertSortBinarySearch
 
 ///***Function  binarySearch***///
    .type   binarySearch, %function
binarySearch:                // // changing value for func
///***Algoritm***///
///***While(1)***///
    mov     x4, #0          // middle = 0
1:
    add     x8, x2, x1      // x8 = left + right
    mov     x6, #2          // x6 = 2
    sdiv    x4, x8, x6      // x4 = middle = (left + right) / 2
    ldrsh   x7, [x5, x4, lsl#1]// x7 = arr[middle]
    cmp     x2, x1          // (left > right)
    b.gt    5f              // go to 5
    cmp     x3, x7          // (key < arr[midd])
    b.lt    2f              
    cmp     x3, x7          // (key > arr[middle])
    b.gt    3f
    cmp     x3, x7
    b.eq    4f
2:
    sub     x4, x4, #1      // middle - 1
    mov     x1, x4          // right = middle - 1
    b       1b
3:
    add     x4, x4, #1      // middle + 1
    mov     x2, x4          // left = middle + 1
    b       1b
5:
    mov     x4, #-1         // return -1
    b       4f              // go to end of func
4:
    mov     x9, x4          // key = -1
    ret
    .size   binarySearch, .-binarySearch

///***Swap Columns***///
     .type   swapColumns, %function
swapColumns: 
///***Algoritm***///
    mov     x5, #0         // x5 = i = 0
0: 
    cmp     x5, x9                  // (i < hight)
    b.ge    2f                      // END
    mov     x7, x3                  // x7 = buf 
    ldrsh   x6, [x0, x1, lsl #1]    // firstIndex value
    ldrsh   x8, [x0, x3, lsl #1]    // secondIndex value
    strh    w6, [x0, x3, lsl #1]
    strh    w8, [x0, x1, lsl #1]
    add     x1, x1, x4//, lsl #1  // p1 += length (move firstIndex)
    add     x3, x3, x4//, lsl #1  // p2 += length(move secondIndex)
    add     x5, x5, #1          // i++
    b       0b
2:
    ret    
    .size   swapColumns, .-swapColumns
