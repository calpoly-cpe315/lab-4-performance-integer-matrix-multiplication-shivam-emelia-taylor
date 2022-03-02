
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
	stp    x29, x30, [sp, -16]!
	add    x29, sp, 0
   mov    x9, #0 // i
   mov    x10, #0 // j
   mov    x11, #0 // k
   mov    x12, #0 // sum
   mov    x13, #0 // a matrix offset
   mov    x14, #0 // b matrix offset
   mov    x15, #0 // c matrix offset

   iloopstart:
      cmp   x9, x3 
      b.eq  end
      mov   x10, #0 // j = 0
      jloopstart:
         cmp   x10, x5 // checking if j < wB
         b.eq  jloopend 
         mov    x11, #0 // k = 0
         mov    x12, #0 // sum = 0  
         kloopstart:
            cmp   x11, x4 // checking if k < wA
            b.eq  kloopend

            /* sum += A[i * wA + k] * B[k * wB + j]; */
            /* calculating a offset */ 
            mul   x6, x9, x4 /* i * wA */
            add   x13, x6, x11
            mov   x7, #4 
            mul   x13, x7, x13
            /* calculate b offset */
            mul   x6, x11, x5
            add   x14, x6, x10
            mul   x14, x7, x14
            /* now add to sum */
            ldrsw   x13, [x1, x13]
            ldrsw   x14, [x2, x14]
            mul   x6, x13, x14
            add   x12, x12, x6 /* add to the running total */
            add   x11, x11, #1 /* add 1 to k */
            bl    kloopstart

         kloopend:
            mul   x6, x9, x5
            add   x6, x6, x10
            mul   x6, x7, x6
            str   x12, [x0, x6]
            add   x10, x10, #1 /* add 1 to j */
            bl    jloopstart  
      jloopend:
         add   x9, x9, #1 /* add 1 to i */
         bl    iloopstart
   end:
      ldp  x29, x30, [sp], 16
      ret


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

