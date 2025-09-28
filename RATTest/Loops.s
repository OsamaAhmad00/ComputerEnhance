.intel_syntax noprefix

.globl dependent_adds
.globl independent_adds

.text

.align 64
dependent_adds:
    add rbx, 1
    add rbx, 1
    dec rcx
    jnz dependent_adds
    ret

.align 64
independent_adds:
    mov rax, rbx
    add rax, 1
    mov rax, rbx
    add rax, 1
    dec rcx
    jnz independent_adds
    ret
