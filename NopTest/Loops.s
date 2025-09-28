.intel_syntax noprefix

.macro nop3
    .byte 0x0f, 0x1f, 0x00
.endm

.globl NOP0
.globl NOP1x1
.globl NOP3x1
.globl NOP1x3
.globl NOP3x3
.globl NOP1x9

.text

NOP0:
    xor rax, rax
1:
    inc rax
    cmp rax, rcx
    jl 1b
    ret

NOP1x1:
    xor rax, rax
1:
    nop
    inc rax
    cmp rax, rcx
    jl 1b
    ret

NOP3x1:
    xor rax, rax
1:
    nop3
    inc rax
    cmp rax, rcx
    jl 1b
    ret

NOP1x3:
    xor rax, rax
1:
    nop
    nop
    nop
    inc rax
    cmp rax, rcx
    jl 1b
    ret

NOP3x3:
    xor rax, rax
1:
    nop3
    nop3
    nop3
    inc rax
    cmp rax, rcx
    jl 1b
    ret

NOP1x9:
    xor rax, rax
1:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc rax
    cmp rax, rcx
    jl 1b
    ret
