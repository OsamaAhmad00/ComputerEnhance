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

.align 64
load1:
    mov rax, [rsi]  # second arg, data pointer
    sub rdi, 1      # first arg, number of repetitions
    jg load1
    ret

.align 64
load2:
    mov rax, [rsi]  # second arg, data pointer
    mov rax, [rsi]  # second arg, data pointer
    sub rdi, 2      # first arg, number of repetitions
    jg load2
    ret

.align 64
load3:
    mov rax, [rsi]  # second arg, data pointer
    mov rax, [rsi]  # second arg, data pointer
    mov rax, [rsi]  # second arg, data pointer
    sub rdi, 3      # first arg, number of repetitions
    jg load3
    ret

.align 64
load4:
    mov rax, [rsi]  # second arg, data pointer
    mov rax, [rsi]  # second arg, data pointer
    mov rax, [rsi]  # second arg, data pointer
    mov rax, [rsi]  # second arg, data pointer
    sub rdi, 4      # first arg, number of repetitions
    jg load4
    ret

.align 64
store1:
    mov [rsi], rax  # second arg, data pointer. will store whatever is in rax
    sub rdi, 1      # first arg, number of repetitions
    jg store1
    ret

.align 64
store2:
    mov [rsi], rax  # second arg, data pointer. will store whatever is in rax
    mov [rsi], rax  # second arg, data pointer. will store whatever is in rax
    sub rdi, 1      # first arg, number of repetitions
    jg store2
    ret

.align 64
store3:
    mov [rsi], rax  # second arg, data pointer. will store whatever is in rax
    mov [rsi], rax  # second arg, data pointer. will store whatever is in rax
    mov [rsi], rax  # second arg, data pointer. will store whatever is in rax
    sub rdi, 1      # first arg, number of repetitions
    jg store3
    ret

.align 64
store4:
    mov [rsi], rax  # second arg, data pointer. will store whatever is in rax
    mov [rsi], rax  # second arg, data pointer. will store whatever is in rax
    mov [rsi], rax  # second arg, data pointer. will store whatever is in rax
    mov [rsi], rax  # second arg, data pointer. will store whatever is in rax
    sub rdi, 1      # first arg, number of repetitions
    jg store4
    ret

