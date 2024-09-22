	.file	"float.s"
	.option nopic
	.attribute arch, "rv64i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	1
	.globl	multiply
	.type	multiply, @function
multiply:
	addi	sp,sp,-32
	sd	s0,24(sp)
	addi	s0,sp,32
	fsw	fa0,-20(s0) # 存储第一个浮点参数 a
	fsw	fa1,-24(s0) # 存储第二个浮点参数 b
	flw	fa4,-20(s0)
	flw	fa5,-24(s0)
	fmul.s	fa5,fa4,fa5   # single calculate
	fmv.s	fa0,fa5       # 将结果存储到返回值寄存器 fa0
	ld	s0,24(sp)
	addi	sp,sp,32
	jr	ra
	.size	multiply, .-multiply
	.section	.rodata
	.align	3
.LC0:
	.string	"Error: Division by zero is not allowed."
	.text
	.align	1
	.globl	divide
	.type	divide, @function
divide:
	addi	sp,sp,-32
	sd	ra,24(sp)
	sd	s0,16(sp)
	addi	s0,sp,32
	fsw	fa0,-20(s0)  # 存储第一个浮点参数 a
	fsw	fa1,-24(s0)  # 存储第二个浮点参数 b
	flw	fa5,-24(s0)  # 加载 b
	fmv.w.x	fa4,zero      # 设置 fa4 为 0，用于检查 b 是否为 0
	feq.s	a5,fa5,fa4    # 检查 b 是否为 0
	bne	a5,zero,.L4   # 如果 b == 0, return 0 
	flw	fa4,-20(s0)
	flw	fa5,-24(s0)
	fdiv.s	fa5,fa4,fa5
	j	.L5
.L4:
	lui	a5,%hi(.LC0)
	addi	a0,a5,%lo(.LC0)
	call	puts
	fmv.w.x	fa5,zero    #return 0
.L5:
	fmv.s	fa0,fa5   #输出div result
	ld	ra,24(sp)
	ld	s0,16(sp)
	addi	sp,sp,32
	jr	ra
	.size	divide, .-divide
	.section	.rodata
	.align	3
.LC1:
	.string	"Enter two numbers (a and b): "
	.align	3
.LC2:
	.string	"%f %f"
	.align	3
.LC3:
	.string	"Multiplication: %.6f\n"
	.align	3
.LC4:
	.string	"Division: %.6f\n"
	.text
	.align	1
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-32
	sd	ra,24(sp)
	sd	s0,16(sp)
	addi	s0,sp,32
	lui	a5,%hi(.LC1)  #提示输入
	addi	a0,a5,%lo(.LC1)
	call	printf
	addi	a4,s0,-32   #store a
	addi	a5,s0,-28   #store b
	mv	a2,a4       # the addr of a
	mv	a1,a5       # the addr of b
	lui	a5,%hi(.LC2)
	addi	a0,a5,%lo(.LC2)
	call	__isoc99_scanf
	
	flw	fa5,-28(s0)  # load b
	flw	fa4,-32(s0)  # load a
	fmv.s	fa1,fa4     #参数入栈
	fmv.s	fa0,fa5
	call	multiply
	fsw	fa0,-20(s0)  #fa0 is the result
	flw	fa5,-20(s0)  #load to fa5
	fcvt.d.s	fa5,fa5  # from single convert to double
	fmv.x.d	a1,fa5          # store the result to integer register
	lui	a5,%hi(.LC3)
	addi	a0,a5,%lo(.LC3)
	call	printf          
	
	flw	fa5,-28(s0)
	flw	fa4,-32(s0)
	fmv.s	fa1,fa4   # fa1 = a
	fmv.s	fa0,fa5   # fa2 = b
	call	divide
	
	fsw	fa0,-24(s0)    
	flw	fa5,-32(s0)
	fmv.w.x	fa4,zero       # let fa4 = 0 
	feq.s	a5,fa5,fa4     # if b == 0 ? yes: a5=1, No: a5 =0
	bne	a5,zero,.L7    # a5 == 1,then  jump out and rt 0
	flw	fa5,-24(s0)    # if a5 == 0, continue load div_res
	fcvt.d.s	fa5,fa5  
	fmv.x.d	a1,fa5     
	lui	a5,%hi(.LC4)
	addi	a0,a5,%lo(.LC4)
	call	printf
.L7:
	li	a5,0
	mv	a0,a5
	ld	ra,24(sp)
	ld	s0,16(sp)
	addi	sp,sp,32
	jr	ra
	.size	main, .-main
	.ident	"GCC: () 12.2.0"
	.section	.note.GNU-stack,"",@progbits