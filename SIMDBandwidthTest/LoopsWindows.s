.intel_syntax noprefix

.globl two_reads_1_byte
.globl two_reads_2_bytes
.globl two_reads_4_bytes
.globl two_reads_8_bytes
.globl two_reads_16_bytes
.globl two_reads_32_bytes

.text

two_reads_1_byte:
    xor rax, rax
.align 64
1:
    add rax, 2
    mov R8B, [rdx + 0]
    mov R8B, [rdx + 1]
    cmp rax, rcx
    jl 1b
    ret

two_reads_2_bytes:
    xor rax, rax
.align 64
1:
    add rax, 4
    mov R8W, [rdx + 0]
    mov R8W, [rdx + 2]
    cmp rax, rcx
    jl 1b
    ret

two_reads_4_bytes:
    xor rax, rax
.align 64
1:
    add rax, 8
    mov R8D, [rdx + 0]
    mov R8D, [rdx + 4]
    cmp rax, rcx
    jl 1b
    ret

two_reads_8_bytes:
    xor rax, rax
.align 64
1:
    add rax, 16
    mov R8, [rdx + 0]
    mov R8, [rdx + 8]
    cmp rax, rcx
    jl 1b
    ret

two_reads_16_bytes:
    xor rax, rax
.align 64
1:
    add rax, 32
    vmovdqu xmm0, [rdx + 0]
    vmovdqu xmm0, [rdx + 16]
    cmp rax, rcx
    jl 1b
    ret

two_reads_32_bytes:
    xor rax, rax
.align 64
1:
    add rax, 64
    vmovdqu ymm0, [rdx + 0]
    vmovdqu ymm0, [rdx + 32]
    cmp rax, rcx
    jl 1b
    ret
