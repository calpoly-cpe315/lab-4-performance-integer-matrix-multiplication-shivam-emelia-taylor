    // intmul function in this file

    .arch armv8-a
    .global intmul

intmul:
   /* x0 = num 1 and return location, x2 = num2
   /* x0 = a, x2 =b, x1=c, x5 = additionC x6=b and result, x7 is temp b
	/*and - carry*/
	stp    x29, x30, [sp, -32]!
	mov    x1, #0       /* x1 = mul c*/
multloop:
	and    x4, x2, #1   /* (b and 1)*/
	cmp    x4, #0       /* (b and 1) != 0*/
	b.eq   cont
        mov    x3, x0        /* x3 = temp a*/ 
        mov    x6, x1        /* x6 = temp c/ add b*/

multaddloop: 
	and    x5, x6, x3
	eor    x6, x6, x3
	lsl    x3, x5, #1

	cmp    x3, #0
	b.ne   multaddloop
	mov    x1, x6

cont:
	lsl    x0, x0, #1
	lsr    x2, x2, #1   
   
	cmp    x2, #0
	b.ne   multloop

	mov    x0, x1
	str    x0, [sp, 16]
	ldp    x29, x30, [sp], 32
	ret
   
