.intel_syntax noprefix

.globl conditional_nop

.text

# This only tests the effect of branches
# taken or not with different patterns in
# the passed array. Whether taken or not,
# no extra work is done (NOP)

conditional_nop:
    xor rax, rax
1:
    mov r10, [rdx + rax]
    inc rax
    test r10, 1
    jnz 2f
    nop
2:
    cmp rax, rcx
    jl 1b
    ret
