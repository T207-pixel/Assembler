 1       .arch armv8-a
 2         //Expression -> a*(-b)*(c/(e+d))-(d+b)/e
 3         // a == 16bit
 4         // b == 16bit
 5         // c == 32bit
 6         // d == 16bit
 7         // e == 32bit
 8         .data
 9         .align 2
10 res:
11         .skip   8
12 a:
13         .2byte -20
14 b:
15         .2byte -4
16 c:
17         .4byte 3
18 d:
19         .2byte 5
20 e:
21         .4byte 2
22         .text
23         .align 2
24         .global _start
25         .type _start, %function
26 _start:
27         adr		x0, a
28         ldrsh    	w0, [x0]
29         adr         	x1, b
30         ldrsh    	w1, [x1]
31         adr          x2, c
32     	   ldrsw        x2, [x2]
33         adr          x3, d
34         ldrsh    	w3, [x3]
35         adr          x4, e
36         ldrsw    	x4, [x4]
37
38         //checking area of allowable values
39         // e != -d
40         adds 	x12, x3, x4
41         b.eq 	exit
42         //e != 0
43         mov 		x13, #0
44         adds 	x14, x13, x4
45         b.eq 	exit
46
47         neg     	w5, w1
49         smull   	x6, w5, w0
50         mul     	x7, x6, x2
51         adds    	x8, x4, x3
52         b.vs    	exit
53         sdiv    	x9, x7, x8
54         adds    	w10, w3, w1
55         b.vs    	exit
56         sdiv    	x11, x10, x4
57         subs    	x12, x9, x11
58         b.vs    	exit
59         adr		x0, res
60         str          x12, [x0]
61         mov 		x0, #0
62         mov		x8, #93
63         svc 		#0
64 exit:
65         mov 		x0, #0
66         mov 		x8, #93
67         svc 		#0
68         .size _start, .-_start
69         //object file
70         // ldrsh -> ldrh dufferences
71         // store in res
72         // zero b.eq connection?

