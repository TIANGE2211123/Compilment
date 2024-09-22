	.file	"matrix.s"
	.option nopic
	.attribute arch, "rv64i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.section	.rodata
	.align	3
.LC0:
	.string	"ERROR!"
	.text
	.align	1
	.globl	array_sum
	.type	array_sum, @function
array_sum:
	addi	sp,sp,-48
	sd	ra,40(sp)
	sd	s0,32(sp)
	fsd	fs0,24(sp)
	addi	s0,sp,48
	sd	a0,-40(s0)  # base of the array
	mv	a5,a1       # Move the pointer to the array into a5
	sw	a5,-44(s0)
	lw	a5,-44(s0)  # load n
	sext.w	a5,a5
	bgt	a5,zero,.L2  # if n >= 0?  continue recursive
	
	fmv.w.x	fa5,zero
	j	.L3
.L2:
	lw	a5,-44(s0)  # load n
	slli	a5,a5,2     # n*4
	addi	a5,a5,-4    #index n-1
	ld	a4,-40(s0)  # load the base addr of array
	add	a5,a4,a5   # the last element addr
	
	flw	fs0,0(a5)  # load array[n-1]
	
	lw	a5,-44(s0)  # ld n
	addiw	a5,a5,-1    # n-1
	sext.w	a5,a5  
	mv	a1,a5       # Move the new value of n into a1
	ld	a0,-40(s0)   # ld array
	call	array_sum   
	
	fmv.s	fa5,fa0     # Move the returned sum from fa0 to fa5
	fadd.s	fa5,fs0,fa5  # add sum 
.L3:
	fmv.s	fa0,fa5   # ret 0
	ld	ra,40(sp)
	ld	s0,32(sp)
	fld	fs0,24(sp)
	addi	sp,sp,48
	jr	ra
	.size	array_sum, .-array_sum
	.section	.rodata
	.align	3
.LC1:
	.string	"Enter the number of elements in the array: "
	.align	3
.LC2:
	.string	"%d"
	.align	3
.LC3:
	.string	"Memory allocation failed!"
	.align	3
.LC4:
	.string	"Enter the elements of the array:"
	.align	3
.LC5:
	.string	"%f"
	.align	3
.LC6:
	.string	"Sum of the array elements: %.2f\n"
	.text
	.align	1
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-48
	sd	ra,40(sp)
	sd	s0,32(sp)
	addi	s0,sp,48
	lui	a5,%hi(.LC1)
	addi	a0,a5,%lo(.LC1)
	call	printf
	
	addi	a5,s0,-40   # n
	mv	a1,a5
	lui	a5,%hi(.LC2)
	addi	a0,a5,%lo(.LC2)
	call	__isoc99_scanf
	
	lw	a5,-40(s0)  # load n
	slli	a5,a5,2    # n*4
	mv	a0,a5    # set size for malloc
	call	malloc
	
	mv	a5,a0     # move the pointer
	sd	a5,-32(s0)  # array 地址
	ld	a5,-32(s0)
	bne	a5,zero,.L5   # if malloc is not freed， 
	
	lui	a5,%hi(.LC3)
	addi	a0,a5,%lo(.LC3)
	call	puts
	li	a5,1     # ret 1, err
	j	.L9
.L5:
	lui	a5,%hi(.LC4)
	addi	a0,a5,%lo(.LC4)
	call	puts
	sw	zero,-20(s0)  # sw i = 0
	j	.L7           #for循环
.L8:
	lw	a5,-20(s0)  # 判断for循环条件
	slli	a5,a5,2   # i*4
	ld	a4,-32(s0)  #arr
	add	a5,a4,a5  #base addr + offset
	mv	a1,a5
	lui	a5,%hi(.LC5)
	addi	a0,a5,%lo(.LC5)  #输入arr[i]
	call	__isoc99_scanf
	lw	a5,-20(s0)   # Load the current index
	addiw	a5,a5,1        # Increment the index
	sw	a5,-20(s0)    # # Store the new index
.L7:
	lw	a4,-40(s0)  # load n
	lw	a5,-20(s0)   # load i
	sext.w	a5,a5
	blt	a5,a4,.L8  # if i< n, 接着读取array[n]
	
	lw	a5,-40(s0)  # load n
	mv	a1,a5     # size of array to a1
	ld	a0,-32(s0)  # base addr of array
	call	array_sum
	
	fsw	fa0,-36(s0)   # store the sum
	flw	fa5,-36(s0)   # load the sum
	fcvt.d.s	fa5,fa5  # convert float to double
	fmv.x.d	a1,fa5       #  Move the double value to a1 for printing
	lui	a5,%hi(.LC6)
	addi	a0,a5,%lo(.LC6)
	call	printf
	ld	a0,-32(s0)   # load pointer to the array
	call	free   
	li	a5,0     # return 0
.L9:
	mv	a0,a5
	ld	ra,40(sp)
	ld	s0,32(sp)
	addi	sp,sp,48
	jr	ra
	.size	main, .-main
	.ident	"GCC: () 12.2.0"
	.section	.note.GNU-stack,"",@progbits