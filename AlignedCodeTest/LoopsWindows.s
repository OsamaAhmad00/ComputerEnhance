.intel_syntax noprefix

.globl aligned_to_64
.globl aligned_to_63
.globl aligned_to_31
.globl aligned_to_15

.text

aligned_to_64:
    xor rax, rax
1:
.align 64
    inc rax
    cmp rax, rcx
    jl 1b
    ret

aligned_to_63:
    xor rax, rax
1:
.align 64
.rept 63
nop
.endr
    inc rax
    cmp rax, rcx
    jl 1b
    ret

aligned_to_31:
    xor rax, rax
1:
.align 64
.rept 31
nop
.endr
    inc rax
    cmp rax, rcx
    jl 1b
    ret

aligned_to_15:
    xor rax, rax
1:
.align 64
.rept 15
nop
.endr
    inc rax
    cmp rax, rcx
    jl 1b
    ret
