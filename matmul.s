
   /* for intadd */
   /* x0 = num 1 and return location, x2 = num2
   /* x3 = temp 1, x4 =temp 2, x5=temp3
	/*and - carry*/

   /* for intmul */
   /* x0 = num 1 and return location, x2 = num2
   /* x3 = a, x4 =b, x1=c, x5 = additionC x6=b and result, x7 is temp b, x2 = temp a
	/*and - carry*/

	.arch armv8-a
	.global matmul

matmul:
	stp    x29, x30, [sp, -64]!
	add    x29, sp, 0
   mov     x9, #0 // i
   mov     x10, #0 // j
   mov     x11, #0 // k
   mov     x12, #0 // sum
   mov     x13, #0 // a matrix offset
   mov     x14, #0 // b matrix offset
   mov     x15, #0 // c matrix offset

   iloopstart:
      cmp   x9, x3 
      b.eq  end
      jloopstart:
         cmp   x10, x5 // checking if j < wB
         b.eq  jloopend 
         mov    x11, #0 // k = 0
         mov    x12, #0 // sum = 0            
         stp   x0, x1 [x29, 16] // save parameter regesters to stack
         stp   x2, x3 [x29, 32]
         stp   x4, x5 [x29, 48]
         kloopstart:
            cmp   x11, x4 // checking if k < wA
            b.eq  kloopend

            /* sum += A[i * wA + k] * B[k * wB + j]; */
            /* calculating a offset */
            mov   x0, x9 
            mov   x2, x4    
            bl    intmul
            mov   x2, x11
            bl    intadd
            mov   x13, x0   /* set a offset */
            /* calculate b offset */
            mov   x0, x11 /* k */
            mov   x2, x5  /* wB */
            bl    intmul
            mov   x2, x10 /* j */
            bl    intadd
            mov   x14, x0 /* set b offset */
            /* now add to sum */
            ldr   x0, [x1, x13]
            ldr   x2, [x2, x14]
            bl    intmul  /* do the matrix mult */
            mov   x2, x12 
            bl    intadd  /* add to the running total */
            mov   x12, x0 /* set the result to the new running total */
            mov   x0, x11
            mov   x2, #1
            bl    intadd
            mov   x11, x0 /* increment k by one, update k to new value */
            bl    kloopstart

         kloopend:
            mov   x0, x9  /* C[i * wB + j] = sum; */
            mov   x2, x5
            bl    intmul  /* i * wB */
            mov   x2, x10 
            bl    intadd  /* + j */
            mov   

            ldp   x0, x1, [x29, 16]
            ldp   x2, x3, [x29, 32]
            ldp   x4, x5, [x29, 48] /* restore parameter registers */
      jloopend:
   
   end:

////////////////////////////////////////////////////////////////////////////////
// You're implementing the following function in ARM Assembly
//! C = A * B
//! @param C          result matrix                           x0
//! @param A          matrix A                                x1
//! @param B          matrix B                                x2
//! @param hA         height of matrix A                      x3
//! @param wA         width of matrix A, height of matrix B   x4
//! @param wB         width of matrix B                       x5
//
//  Note that while A, B, and C represent two-dimensional matrices,
//  they have all been allocated linearly. This means that the elements
//  in each row are sequential in memory, and that the first element
//  of the second row immedialely follows the last element in the first
//  row, etc. 
//
//void matmul(int* C, const int* A, const int* B, unsigned int hA, 
//    unsigned int wA, unsigned int wB)
//{
//  for (unsigned int i = 0; i < hA; ++i)
//    for (unsigned int j = 0; j < wB; ++j) {
//      int sum = 0;
//      for (unsigned int k = 0; k < wA; ++k) {
//        sum += A[i * wA + k] * B[k * wB + j];
//      }
//      C[i * wB + j] = sum;
//    }
//}
////////////////////////////////////////////////////////////////////////////////