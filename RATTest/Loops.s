.intel_syntax noprefix

.globl dependent_adds_win
.globl independent_adds_win

.globl dependent_adds_linux
.globl independent_adds_linux

.text

.align 64
dependent_adds_win:
    add rbx, 1
    add rbx, 1
    dec rcx
    jnz dependent_adds_win
    ret

.align 64
independent_adds_win:
    mov rax, rbx
    add rax, 1
    mov rax, rbx
    add rax, 1
    dec rcx
    jnz independent_adds_win
    ret

.align 64
dependent_adds_linux:
    add rbx, 1
    add rbx, 1
    dec rdi
    jnz dependent_adds_linux
    ret

.align 64
independent_adds_linux:
    mov rax, rbx
    add rax, 1
    mov rax, rbx
    add rax, 1
    dec rdi
    jnz independent_adds_linux
    ret
