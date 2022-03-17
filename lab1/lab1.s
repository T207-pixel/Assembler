      .arch armv8-a
        //Expression -> a*(-b)*(c/(e+d))-(d+b)/e
        // a == 16bit
        // b == 16bit
        // c == 32bit
        // d == 16bit
        // e == 32bit
        .data
        .align 2
res:
        .skip   8
a:
        .2byte -20
b:
        .2byte -4
c:
        .4byte 3
d:
        .2byte 5
e:
        .4byte 2
        .text
        .align 2
        .global _start
        .type _start, %function
_start:
        adr		x0, a
        ldrsh    	w0, [x0]
        adr         	x1, b
        ldrsh    	w1, [x1]
        adr          x2, c
    	   ldrsw        x2, [x2]
        adr          x3, d
        ldrsh    	w3, [x3]
        adr          x4, e
        ldrsw    	x4, [x4]

        //checking area of allowable values
        // e != -d
        adds 	x12, x3, x4
        b.eq 	exit
        //e != 0
        mov 		x13, #0
        adds 	x14, x13, x4
        b.eq 	exit

        neg     	w5, w1
        smull   	x6, w5, w0
        mul     	x7, x6, x2
        adds    	x8, x4, x3
        b.vs    	exit
        sdiv    	x9, x7, x8
        adds    	w10, w3, w1
        b.vs    	exit
        sdiv    	x11, x10, x4
        subs    	x12, x9, x11
        b.vs    	exit
        adr		x0, res
        str          x12, [x0]
        mov 		x0, #0
        mov		x8, #93
        svc 		#0
exit:
        mov 		x0, #0
        mov 		x8, #93
        svc 		#0
      .size _start, .-_start
      //object file
      // ldrsh -> ldrh dufferences
      // store in res
      // zero b.eq connection?

