    // intadd function in this file

    .arch armv8-a
    .global intadd

intadd:
   /* x0 = num 1 and return location, x2 = num2
   /* x3 = temp 1, x4 =temp 2, x5=temp3
	/*and - carry*/
	stp    x29, x30, [sp, -16]!

	mov   x3, x0
	mov   x4, x2
plusloop: 
	and   x5, x4, x3
	eor   x4, x4, x3
	lsl   x5, x5, #1
	mov   x3, x5

	cmp   x3, #0
	b.ne  plusloop

	mov   x0, x4

	ldp    x29, x30, [sp], 16
	ret
