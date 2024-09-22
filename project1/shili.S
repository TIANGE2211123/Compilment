.file "test.c"
.option nopic
.attribute arch, "rv64i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0"
.attribute unaligned_access, 0
.attribute stack_align, 16

.text
.align 1
.globl max
.type max, @function
max:
    mv a5,a0           # 将第一个参数拷贝到 a5
    bge a0,a1,.L2      # 如果 a0 >= a1，跳转到 .L2
    mv a5,a1           # 否则，将 a1 拷贝到 a5
.L2:
    sext.w a0,a5       # 将 a5 符号扩展到 64 位
    ret                 # 返回到调用者
.size max, .-max

.section .rodata.str1.8,"aMS",@progbits,1
.align 3
.LC0:
    .string "%d %d"    # 输入格式化字符串
.align 3
.LC1:
    .string "max is: %d\n" # 输出格式化字符串

.section .text.startup,"ax",@progbits
.align 1
.globl main
.type main, @function
main:
    addi sp,sp,-32      # 调整栈指针，分配栈空间
    sd s0,16(sp)        # 保存 s0 到栈
    sd s1,8(sp)         # 保存 s1 到栈
    lui s0,%hi(a)       # 加载全局变量 a 的高位地址
    lui s1,%hi(b)       # 加载全局变量 b 的高位地址
    lui a0,%hi(.LC0)    # 加载格式化字符串地址的高位
    addi a2,s1,%lo(b)   # 加载 b 的低位地址
    addi a1,s0,%lo(a)   # 加载 a 的低位地址
    addi a0,a0,%lo(.LC0) # 完成格式化字符串地址的加载
    sd ra,24(sp)        # 保存返回地址 ra 到栈
    call __isoc99_scanf # 调用 scanf 读取输入
    lw a1,%lo(b)(s1)    # 从 b 中加载整数值
    lw a0,%lo(a)(s0)    # 从 a 中加载整数值
    call max            # 调用 max 函数计算最大值
    mv a1,a0           # 将返回的最大值存入 a1
    lui a0,%hi(.LC1)    # 加载输出格式化字符串地址的高位
    addi a0,a0,%lo(.LC1) # 完成输出格式化字符串地址的加载
    call printf         # 调用 printf 输出最大值
    ld ra,24(sp)        # 恢复返回地址 ra
    ld s0,16(sp)        # 恢复 s0
    ld s1,8(sp)         # 恢复 s1
    li a0,0             # 返回值设为 0
    addi sp,sp,32       # 恢复栈指针
    jr ra               # 返回到调用者

.globl b
.globl a
.section .sbss,"aw",@nobits
.align 2
.type b, @object
.size b, 4
b:
    .zero 4            # b 初始化为 0
.type a, @object
.size a, 4
a:
    .zero 4            # a 初始化为 0

.ident "GCC: () 12.2.0"
.section .note.GNU-stack,"",@progbits
