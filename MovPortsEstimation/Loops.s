.intel_syntax noprefix

.globl load1
.globl load2
.globl load3
.globl load4
.globl store1
.globl store2
.globl store3
.globl store4

.text

# To make sure we're taking memory bandwidth
# out of the equation, we're going to load/store
# the same value over and over

# Linux ABI

load1:
.align 64
    mov rax, [rsi]  # second arg, data pointer
    sub rdi, 1      # first arg, number of repetitions
    jg load1
    ret

load2:
.align 64
    mov rax, [rsi]  # second arg, data pointer
    mov rax, [rsi]  # second arg, data pointer
    sub rdi, 2      # first arg, number of repetitions
    jg load2
    ret

load3:
.align 64
    mov rax, [rsi]  # second arg, data pointer
    mov rax, [rsi]  # second arg, data pointer
    mov rax, [rsi]  # second arg, data pointer
    sub rdi, 3      # first arg, number of repetitions
    jg load3
    ret

load4:
.align 64
    mov rax, [rsi]  # second arg, data pointer
    mov rax, [rsi]  # second arg, data pointer
    mov rax, [rsi]  # second arg, data pointer
    mov rax, [rsi]  # second arg, data pointer
    sub rdi, 4      # first arg, number of repetitions
    jg load4
    ret

store1:
.align 64
    mov [rsi], rax  # second arg, data pointer. will store whatever is in rax
    sub rdi, 1      # first arg, number of repetitions
    jg store1
    ret

store2:
.align 64
    mov [rsi], rax  # second arg, data pointer. will store whatever is in rax
    mov [rsi], rax  # second arg, data pointer. will store whatever is in rax
    sub rdi, 1      # first arg, number of repetitions
    jg store2
    ret

store3:
.align 64
    mov [rsi], rax  # second arg, data pointer. will store whatever is in rax
    mov [rsi], rax  # second arg, data pointer. will store whatever is in rax
    mov [rsi], rax  # second arg, data pointer. will store whatever is in rax
    sub rdi, 1      # first arg, number of repetitions
    jg store3
    ret

store4:
.align 64
    mov [rsi], rax  # second arg, data pointer. will store whatever is in rax
    mov [rsi], rax  # second arg, data pointer. will store whatever is in rax
    mov [rsi], rax  # second arg, data pointer. will store whatever is in rax
    mov [rsi], rax  # second arg, data pointer. will store whatever is in rax
    sub rdi, 1      # first arg, number of repetitions
    jg store4
    ret

