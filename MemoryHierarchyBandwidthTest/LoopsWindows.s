.intel_syntax noprefix

.globl touch_2KB
.globl touch_2KB_6_loads
.globl touch_2KB_8_loads
.globl touch_2KB_10_loads
.globl touch_2KB_12_loads
.globl touch_2KB_14_loads
.globl touch_2KB_16_loads
.globl touch_2KB_18_loads
.globl touch_2KB_19_loads
.globl touch_2KB_20_loads
.globl touch_2KB_21_loads
.globl touch_2KB_22_loads
.globl touch_2KB_24_loads
.globl touch_2KB_32_loads
.globl touch_2KB_40_loads
.globl touch_2KB_48_loads
.globl touch_2KB_64_loads
.globl touch_4KB
.globl touch_8KB
.globl touch_16KB
.globl touch_32KB
.globl touch_64KB
.globl touch_128KB
.globl touch_256KB
.globl touch_512KB
.globl touch_1MB
.globl touch_2MB
.globl touch_4MB
.globl touch_8MB
.globl touch_16MB
.globl touch_32MB
.globl touch_64MB
.globl touch_128MB
.globl touch_256MB
.globl touch_512MB
.globl touch_1GB

.text

# Read As much bytes as passed by the first arg
# Touch 2KB over and over
# Each iteration reads 128 bytes (32 * 4)
touch_2KB:
    xor rax, rax
    xor r8, r8  # Offset
.align 64
1:
    add rax, 128  # Count 128 bytes are read
    and r8, 2047  # 2^11 - 1 mask
    mov r9, r8    # Offset + address will be stored here
    add r9, rdx   # Add the address to the offset
    add r8, 128   # Increase the offset for next iteration
    vmovdqa ymm0, [r9 + 0 ]
    vmovdqa ymm1, [r9 + 32]
    vmovdqa ymm2, [r9 + 64]
    vmovdqa ymm3, [r9 + 96]
    cmp rax, rcx
    jl 1b
    ret

# Read As much bytes as passed by the first arg
# Touch 2KB over and over
# Each iteration reads 192 bytes (32 * 6)
touch_2KB_6_loads:
    xor rax, rax
    xor r8, r8  # Offset
.align 64
1:
    add rax, 192  # Count 192 bytes are read
    and r8, 2047  # 2^11 - 1 mask
    mov r9, r8    # Offset + address will be stored here
    add r9, rdx   # Add the address to the offset
    add r8, 192   # Increase the offset for next iteration
    vmovdqa ymm0, [r9 + 0  ]
    vmovdqa ymm1, [r9 + 32 ]
    vmovdqa ymm2, [r9 + 64 ]
    vmovdqa ymm3, [r9 + 96 ]
    vmovdqa ymm0, [r9 + 128]
    vmovdqa ymm1, [r9 + 160]
    cmp rax, rcx
    jl 1b
    ret

# Read As much bytes as passed by the first arg
# Touch 2KB over and over
# Each iteration reads 256 bytes (32 * 8)
touch_2KB_8_loads:
    xor rax, rax
    xor r8, r8  # Offset
.align 64
1:
    add rax, 256  # Count 256 bytes are read
    and r8, 2047  # 2^11 - 1 mask
    mov r9, r8    # Offset + address will be stored here
    add r9, rdx   # Add the address to the offset
    add r8, 256   # Increase the offset for next iteration
    vmovdqa ymm0, [r9 + 0  ]
    vmovdqa ymm1, [r9 + 32 ]
    vmovdqa ymm2, [r9 + 64 ]
    vmovdqa ymm3, [r9 + 96 ]
    vmovdqa ymm0, [r9 + 128]
    vmovdqa ymm1, [r9 + 160]
    vmovdqa ymm2, [r9 + 192]
    vmovdqa ymm3, [r9 + 224]
    cmp rax, rcx
    jl 1b
    ret

# Read As much bytes as passed by the first arg
# Touch 2KB over and over
# Each iteration reads 320 bytes (32 * 10)
touch_2KB_10_loads:
    xor rax, rax
    xor r8, r8  # Offset
.align 64
1:
    add rax, 320  # Count 320 bytes are read
    and r8, 2047  # 2^11 - 1 mask
    mov r9, r8    # Offset + address will be stored here
    add r9, rdx   # Add the address to the offset
    add r8, 320   # Increase the offset for next iteration
    vmovdqa ymm0, [r9 + 0  ]
    vmovdqa ymm1, [r9 + 32 ]
    vmovdqa ymm2, [r9 + 64 ]
    vmovdqa ymm3, [r9 + 96 ]
    vmovdqa ymm0, [r9 + 128]
    vmovdqa ymm1, [r9 + 160]
    vmovdqa ymm2, [r9 + 192]
    vmovdqa ymm3, [r9 + 224]
    vmovdqa ymm0, [r9 + 256]
    vmovdqa ymm1, [r9 + 288]
    cmp rax, rcx
    jl 1b
    ret

# Read As much bytes as passed by the first arg
# Touch 2KB over and over
# Each iteration reads 384 bytes (32 * 12)
# But only touches 256 bytes (32 * 8)
touch_2KB_12_loads:
    xor rax, rax
    xor r8, r8  # Offset
.align 64
1:
    add rax, 384
    and r8, 2047
    mov r9, r8
    add r9, rdx
    add r8, 256
    vmovdqa ymm0, [r9 + 0   ]
    vmovdqa ymm1, [r9 + 32  ]
    vmovdqa ymm2, [r9 + 64  ]
    vmovdqa ymm3, [r9 + 96  ]
    vmovdqa ymm0, [r9 + 128 ]
    vmovdqa ymm1, [r9 + 160 ]
    vmovdqa ymm2, [r9 + 192 ]
    vmovdqa ymm3, [r9 + 224 ]
    vmovdqa ymm0, [r9 + 0   ]
    vmovdqa ymm1, [r9 + 32  ]
    vmovdqa ymm2, [r9 + 64  ]
    vmovdqa ymm3, [r9 + 96  ]
    cmp rax, rcx
    jl 1b
    ret

# Read As much bytes as passed by the first arg
# Touch 2KB over and over
# Each iteration reads 448 bytes (32 * 14)
# But only touches 256 bytes (32 * 8)
touch_2KB_14_loads:
    xor rax, rax
    xor r8, r8  # Offset
.align 64
1:
    add rax, 448
    and r8, 2047
    mov r9, r8
    add r9, rdx
    add r8, 256
    vmovdqa ymm0, [r9 + 0   ]
    vmovdqa ymm1, [r9 + 32  ]
    vmovdqa ymm2, [r9 + 64  ]
    vmovdqa ymm3, [r9 + 96  ]
    vmovdqa ymm0, [r9 + 128 ]
    vmovdqa ymm1, [r9 + 160 ]
    vmovdqa ymm2, [r9 + 192 ]
    vmovdqa ymm3, [r9 + 224 ]
    vmovdqa ymm0, [r9 + 0   ]
    vmovdqa ymm1, [r9 + 32  ]
    vmovdqa ymm2, [r9 + 64  ]
    vmovdqa ymm3, [r9 + 96  ]
    vmovdqa ymm0, [r9 + 128 ]
    vmovdqa ymm1, [r9 + 160 ]
    cmp rax, rcx
    jl 1b
    ret

# Read As much bytes as passed by the first arg
# Touch 2KB over and over
# Each iteration reads 512 bytes (32 * 16)
touch_2KB_16_loads:
    xor rax, rax
    xor r8, r8  # Offset
.align 64
1:
    add rax, 512  # Count 512 bytes are read
    and r8, 2047  # 2^11 - 1 mask
    mov r9, r8    # Offset + address will be stored here
    add r9, rdx   # Add the address to the offset
    add r8, 512   # Increase the offset for next iteration
    vmovdqa ymm0, [r9 + 0  ]
    vmovdqa ymm1, [r9 + 32 ]
    vmovdqa ymm2, [r9 + 64 ]
    vmovdqa ymm3, [r9 + 96 ]
    vmovdqa ymm0, [r9 + 128]
    vmovdqa ymm1, [r9 + 160]
    vmovdqa ymm2, [r9 + 192]
    vmovdqa ymm3, [r9 + 224]
    vmovdqa ymm0, [r9 + 256]
    vmovdqa ymm1, [r9 + 288]
    vmovdqa ymm2, [r9 + 320]
    vmovdqa ymm3, [r9 + 352]
    vmovdqa ymm0, [r9 + 384]
    vmovdqa ymm1, [r9 + 416]
    vmovdqa ymm2, [r9 + 448]
    vmovdqa ymm3, [r9 + 480]
    cmp rax, rcx
    jl 1b
    ret

# Read As much bytes as passed by the first arg
# Touch 2KB over and over
# Each iteration reads 576 bytes (32 * 18)
# But only touches 512 bytes (32 * 16)
touch_2KB_18_loads:
    xor rax, rax
    xor r8, r8  # Offset
.align 64
1:
    add rax, 576
    and r8, 2047
    mov r9, r8
    add r9, rdx
    add r8, 512
    vmovdqa ymm0, [r9 + 0   ]
    vmovdqa ymm1, [r9 + 32  ]
    vmovdqa ymm2, [r9 + 64  ]
    vmovdqa ymm3, [r9 + 96  ]
    vmovdqa ymm0, [r9 + 128 ]
    vmovdqa ymm1, [r9 + 160 ]
    vmovdqa ymm2, [r9 + 192 ]
    vmovdqa ymm3, [r9 + 224 ]
    vmovdqa ymm0, [r9 + 256 ]
    vmovdqa ymm1, [r9 + 288 ]
    vmovdqa ymm2, [r9 + 320 ]
    vmovdqa ymm3, [r9 + 352 ]
    vmovdqa ymm0, [r9 + 384 ]
    vmovdqa ymm1, [r9 + 416 ]
    vmovdqa ymm2, [r9 + 448 ]
    vmovdqa ymm3, [r9 + 480 ]
    vmovdqa ymm0, [r9 + 0   ]
    vmovdqa ymm1, [r9 + 32  ]
    cmp rax, rcx
    jl 1b
    ret

# Read As much bytes as passed by the first arg
# Touch 2KB over and over
# Each iteration reads 608 bytes (32 * 19)
# But only touches 512 bytes (32 * 16)
touch_2KB_19_loads:
    xor rax, rax
    xor r8, r8  # Offset
.align 64
1:
    add rax, 608
    and r8, 2047
    mov r9, r8
    add r9, rdx
    add r8, 512
    vmovdqa ymm0, [r9 + 0   ]
    vmovdqa ymm1, [r9 + 32  ]
    vmovdqa ymm2, [r9 + 64  ]
    vmovdqa ymm3, [r9 + 96  ]
    vmovdqa ymm0, [r9 + 128 ]
    vmovdqa ymm1, [r9 + 160 ]
    vmovdqa ymm2, [r9 + 192 ]
    vmovdqa ymm3, [r9 + 224 ]
    vmovdqa ymm0, [r9 + 256 ]
    vmovdqa ymm1, [r9 + 288 ]
    vmovdqa ymm2, [r9 + 320 ]
    vmovdqa ymm3, [r9 + 352 ]
    vmovdqa ymm0, [r9 + 384 ]
    vmovdqa ymm1, [r9 + 416 ]
    vmovdqa ymm2, [r9 + 448 ]
    vmovdqa ymm3, [r9 + 480 ]
    vmovdqa ymm0, [r9 + 0   ]
    vmovdqa ymm1, [r9 + 32  ]
    vmovdqa ymm2, [r9 + 64  ]
    cmp rax, rcx
    jl 1b
    ret

# Read As much bytes as passed by the first arg
# Touch 2KB over and over
# Each iteration reads 640 bytes (32 * 20)
# But only touches 512 bytes (32 * 16)
touch_2KB_20_loads:
    xor rax, rax
    xor r8, r8  # Offset
.align 64
1:
    add rax, 640
    and r8, 2047
    mov r9, r8
    add r9, rdx
    add r8, 512
    vmovdqa ymm0, [r9 + 0   ]
    vmovdqa ymm1, [r9 + 32  ]
    vmovdqa ymm2, [r9 + 64  ]
    vmovdqa ymm3, [r9 + 96  ]
    vmovdqa ymm0, [r9 + 128 ]
    vmovdqa ymm1, [r9 + 160 ]
    vmovdqa ymm2, [r9 + 192 ]
    vmovdqa ymm3, [r9 + 224 ]
    vmovdqa ymm0, [r9 + 256 ]
    vmovdqa ymm1, [r9 + 288 ]
    vmovdqa ymm2, [r9 + 320 ]
    vmovdqa ymm3, [r9 + 352 ]
    vmovdqa ymm0, [r9 + 384 ]
    vmovdqa ymm1, [r9 + 416 ]
    vmovdqa ymm2, [r9 + 448 ]
    vmovdqa ymm3, [r9 + 480 ]
    vmovdqa ymm0, [r9 + 0   ]
    vmovdqa ymm1, [r9 + 32  ]
    cmp rax, rcx
    jl 1b
    ret

# Read As much bytes as passed by the first arg
# Touch 2KB over and over
# Each iteration reads 672 bytes (32 * 21)
# But only touches 512 bytes (32 * 16)
touch_2KB_21_loads:
    xor rax, rax
    xor r8, r8  # Offset
.align 64
1:
    add rax, 672
    and r8, 2047
    mov r9, r8
    add r9, rdx
    add r8, 512
    vmovdqa ymm0, [r9 + 0   ]
    vmovdqa ymm1, [r9 + 32  ]
    vmovdqa ymm2, [r9 + 64  ]
    vmovdqa ymm3, [r9 + 96  ]
    vmovdqa ymm0, [r9 + 128 ]
    vmovdqa ymm1, [r9 + 160 ]
    vmovdqa ymm2, [r9 + 192 ]
    vmovdqa ymm3, [r9 + 224 ]
    vmovdqa ymm0, [r9 + 256 ]
    vmovdqa ymm1, [r9 + 288 ]
    vmovdqa ymm2, [r9 + 320 ]
    vmovdqa ymm3, [r9 + 352 ]
    vmovdqa ymm0, [r9 + 384 ]
    vmovdqa ymm1, [r9 + 416 ]
    vmovdqa ymm2, [r9 + 448 ]
    vmovdqa ymm3, [r9 + 480 ]
    vmovdqa ymm0, [r9 + 0   ]
    vmovdqa ymm1, [r9 + 32  ]
    vmovdqa ymm2, [r9 + 64  ]
    vmovdqa ymm3, [r9 + 96  ]
    cmp rax, rcx
    jl 1b
    ret

# Read As much bytes as passed by the first arg
# Touch 2KB over and over
# Each iteration reads 704 bytes (32 * 22)
# But only touches 512 bytes (32 * 16)
touch_2KB_22_loads:
    xor rax, rax
    xor r8, r8  # Offset
.align 64
1:
    add rax, 704
    and r8, 2047
    mov r9, r8
    add r9, rdx
    add r8, 512
    vmovdqa ymm0, [r9 + 0   ]
    vmovdqa ymm1, [r9 + 32  ]
    vmovdqa ymm2, [r9 + 64  ]
    vmovdqa ymm3, [r9 + 96  ]
    vmovdqa ymm0, [r9 + 128 ]
    vmovdqa ymm1, [r9 + 160 ]
    vmovdqa ymm2, [r9 + 192 ]
    vmovdqa ymm3, [r9 + 224 ]
    vmovdqa ymm0, [r9 + 256 ]
    vmovdqa ymm1, [r9 + 288 ]
    vmovdqa ymm2, [r9 + 320 ]
    vmovdqa ymm3, [r9 + 352 ]
    vmovdqa ymm0, [r9 + 384 ]
    vmovdqa ymm1, [r9 + 416 ]
    vmovdqa ymm2, [r9 + 448 ]
    vmovdqa ymm3, [r9 + 480 ]
    vmovdqa ymm0, [r9 + 0   ]
    vmovdqa ymm1, [r9 + 32  ]
    vmovdqa ymm2, [r9 + 64  ]
    vmovdqa ymm3, [r9 + 96  ]
    vmovdqa ymm0, [r9 + 128 ]
    vmovdqa ymm1, [r9 + 160 ]
    cmp rax, rcx
    jl 1b
    ret

# Read As much bytes as passed by the first arg
# Touch 2KB over and over
# Each iteration reads 768 bytes (32 * 24)
# But only touches 512 bytes (32 * 16)
touch_2KB_24_loads:
    xor rax, rax
    xor r8, r8  # Offset
.align 64
1:
    add rax, 768   # Count 768 bytes are read
    and r8, 2047   # 2^11 - 1 mask
    mov r9, r8     # Offset + address will be stored here
    add r9, rdx    # Add the address to the offset
    add r8, 512    # Increase the offset for next iteration
    vmovdqa ymm0, [r9 + 0   ]
    vmovdqa ymm1, [r9 + 32  ]
    vmovdqa ymm2, [r9 + 64  ]
    vmovdqa ymm3, [r9 + 96  ]
    vmovdqa ymm0, [r9 + 128 ]
    vmovdqa ymm1, [r9 + 160 ]
    vmovdqa ymm2, [r9 + 192 ]
    vmovdqa ymm3, [r9 + 224 ]
    vmovdqa ymm0, [r9 + 256 ]
    vmovdqa ymm1, [r9 + 288 ]
    vmovdqa ymm2, [r9 + 320 ]
    vmovdqa ymm3, [r9 + 352 ]
    vmovdqa ymm0, [r9 + 384 ]
    vmovdqa ymm1, [r9 + 416 ]
    vmovdqa ymm2, [r9 + 448 ]
    vmovdqa ymm3, [r9 + 480 ]
    vmovdqa ymm0, [r9 + 0   ]
    vmovdqa ymm1, [r9 + 32  ]
    vmovdqa ymm2, [r9 + 64  ]
    vmovdqa ymm3, [r9 + 96  ]
    vmovdqa ymm0, [r9 + 128 ]
    vmovdqa ymm1, [r9 + 160 ]
    vmovdqa ymm2, [r9 + 192 ]
    vmovdqa ymm3, [r9 + 224 ]
    cmp rax, rcx
    jl 1b
    ret

# Read As much bytes as passed by the first arg
# Touch 2KB over and over
# Each iteration reads 1024 bytes (32 * 32)
touch_2KB_32_loads:
    xor rax, rax
    xor r8, r8  # Offset
.align 64
1:
    add rax, 1024  # Count 1024 bytes are read
    and r8, 2047   # 2^11 - 1 mask
    mov r9, r8     # Offset + address will be stored here
    add r9, rdx    # Add the address to the offset
    add r8, 1024   # Increase the offset for next iteration
    vmovdqa ymm0, [r9 + 0   ]
    vmovdqa ymm1, [r9 + 32  ]
    vmovdqa ymm2, [r9 + 64  ]
    vmovdqa ymm3, [r9 + 96  ]
    vmovdqa ymm0, [r9 + 128 ]
    vmovdqa ymm1, [r9 + 160 ]
    vmovdqa ymm2, [r9 + 192 ]
    vmovdqa ymm3, [r9 + 224 ]
    vmovdqa ymm0, [r9 + 256 ]
    vmovdqa ymm1, [r9 + 288 ]
    vmovdqa ymm2, [r9 + 320 ]
    vmovdqa ymm3, [r9 + 352 ]
    vmovdqa ymm0, [r9 + 384 ]
    vmovdqa ymm1, [r9 + 416 ]
    vmovdqa ymm2, [r9 + 448 ]
    vmovdqa ymm3, [r9 + 480 ]
    vmovdqa ymm0, [r9 + 512 ]
    vmovdqa ymm1, [r9 + 544 ]
    vmovdqa ymm2, [r9 + 576 ]
    vmovdqa ymm3, [r9 + 608 ]
    vmovdqa ymm0, [r9 + 640 ]
    vmovdqa ymm1, [r9 + 672 ]
    vmovdqa ymm2, [r9 + 704 ]
    vmovdqa ymm3, [r9 + 736 ]
    vmovdqa ymm0, [r9 + 768 ]
    vmovdqa ymm1, [r9 + 800 ]
    vmovdqa ymm2, [r9 + 832 ]
    vmovdqa ymm3, [r9 + 864 ]
    vmovdqa ymm0, [r9 + 896 ]
    vmovdqa ymm1, [r9 + 928 ]
    vmovdqa ymm2, [r9 + 960 ]
    vmovdqa ymm3, [r9 + 992 ]
    cmp rax, rcx
    jl 1b
    ret

# Read As much bytes as passed by the first arg
# Touch 2KB over and over
# Each iteration reads 1280 bytes (32 * 40)
# But only touches 1024 bytes (32 * 32)
touch_2KB_40_loads:
    xor rax, rax
    xor r8, r8  # Offset
.align 64
1:
    add rax, 1280  # Count 1280 bytes are read
    and r8, 2047   # 2^11 - 1 mask
    mov r9, r8     # Offset + address will be stored here
    add r9, rdx    # Add the address to the offset
    add r8, 1024   # Increase the offset for next iteration
    vmovdqa ymm0, [r9 + 0   ]
    vmovdqa ymm1, [r9 + 32  ]
    vmovdqa ymm2, [r9 + 64  ]
    vmovdqa ymm3, [r9 + 96  ]
    vmovdqa ymm0, [r9 + 128 ]
    vmovdqa ymm1, [r9 + 160 ]
    vmovdqa ymm2, [r9 + 192 ]
    vmovdqa ymm3, [r9 + 224 ]
    vmovdqa ymm0, [r9 + 256 ]
    vmovdqa ymm1, [r9 + 288 ]
    vmovdqa ymm2, [r9 + 320 ]
    vmovdqa ymm3, [r9 + 352 ]
    vmovdqa ymm0, [r9 + 384 ]
    vmovdqa ymm1, [r9 + 416 ]
    vmovdqa ymm2, [r9 + 448 ]
    vmovdqa ymm3, [r9 + 480 ]
    vmovdqa ymm0, [r9 + 512 ]
    vmovdqa ymm1, [r9 + 544 ]
    vmovdqa ymm2, [r9 + 576 ]
    vmovdqa ymm3, [r9 + 608 ]
    vmovdqa ymm0, [r9 + 640 ]
    vmovdqa ymm1, [r9 + 672 ]
    vmovdqa ymm2, [r9 + 704 ]
    vmovdqa ymm3, [r9 + 736 ]
    vmovdqa ymm0, [r9 + 768 ]
    vmovdqa ymm1, [r9 + 800 ]
    vmovdqa ymm2, [r9 + 832 ]
    vmovdqa ymm3, [r9 + 864 ]
    vmovdqa ymm0, [r9 + 896 ]
    vmovdqa ymm1, [r9 + 928 ]
    vmovdqa ymm2, [r9 + 960 ]
    vmovdqa ymm3, [r9 + 992 ]
    vmovdqa ymm0, [r9 + 0   ]
    vmovdqa ymm1, [r9 + 32  ]
    vmovdqa ymm2, [r9 + 64  ]
    vmovdqa ymm3, [r9 + 96  ]
    vmovdqa ymm0, [r9 + 128 ]
    vmovdqa ymm1, [r9 + 160 ]
    vmovdqa ymm2, [r9 + 192 ]
    vmovdqa ymm3, [r9 + 224 ]
    cmp rax, rcx
    jl 1b
    ret

# Read As much bytes as passed by the first arg
# Touch 2KB over and over
# Each iteration reads 1536 bytes (32 * 48)
# But only touches 1024 bytes (32 * 32)
touch_2KB_48_loads:
    xor rax, rax
    xor r8, r8  # Offset
.align 64
1:
    add rax, 1536  # Count 1536 bytes are read
    and r8, 2047   # 2^11 - 1 mask
    mov r9, r8     # Offset + address will be stored here
    add r9, rdx    # Add the address to the offset
    add r8, 1024   # Increase the offset for next iteration
    vmovdqa ymm0, [r9 + 0   ]
    vmovdqa ymm1, [r9 + 32  ]
    vmovdqa ymm2, [r9 + 64  ]
    vmovdqa ymm3, [r9 + 96  ]
    vmovdqa ymm0, [r9 + 128 ]
    vmovdqa ymm1, [r9 + 160 ]
    vmovdqa ymm2, [r9 + 192 ]
    vmovdqa ymm3, [r9 + 224 ]
    vmovdqa ymm0, [r9 + 256 ]
    vmovdqa ymm1, [r9 + 288 ]
    vmovdqa ymm2, [r9 + 320 ]
    vmovdqa ymm3, [r9 + 352 ]
    vmovdqa ymm0, [r9 + 384 ]
    vmovdqa ymm1, [r9 + 416 ]
    vmovdqa ymm2, [r9 + 448 ]
    vmovdqa ymm3, [r9 + 480 ]
    vmovdqa ymm0, [r9 + 512 ]
    vmovdqa ymm1, [r9 + 544 ]
    vmovdqa ymm2, [r9 + 576 ]
    vmovdqa ymm3, [r9 + 608 ]
    vmovdqa ymm0, [r9 + 640 ]
    vmovdqa ymm1, [r9 + 672 ]
    vmovdqa ymm2, [r9 + 704 ]
    vmovdqa ymm3, [r9 + 736 ]
    vmovdqa ymm0, [r9 + 768 ]
    vmovdqa ymm1, [r9 + 800 ]
    vmovdqa ymm2, [r9 + 832 ]
    vmovdqa ymm3, [r9 + 864 ]
    vmovdqa ymm0, [r9 + 896 ]
    vmovdqa ymm1, [r9 + 928 ]
    vmovdqa ymm2, [r9 + 960 ]
    vmovdqa ymm3, [r9 + 992 ]
    vmovdqa ymm0, [r9 + 0   ]
    vmovdqa ymm1, [r9 + 32  ]
    vmovdqa ymm2, [r9 + 64  ]
    vmovdqa ymm3, [r9 + 96  ]
    vmovdqa ymm0, [r9 + 128 ]
    vmovdqa ymm1, [r9 + 160 ]
    vmovdqa ymm2, [r9 + 192 ]
    vmovdqa ymm3, [r9 + 224 ]
    vmovdqa ymm0, [r9 + 256 ]
    vmovdqa ymm1, [r9 + 288 ]
    vmovdqa ymm2, [r9 + 320 ]
    vmovdqa ymm3, [r9 + 352 ]
    vmovdqa ymm0, [r9 + 384 ]
    vmovdqa ymm1, [r9 + 416 ]
    vmovdqa ymm2, [r9 + 448 ]
    vmovdqa ymm3, [r9 + 480 ]
    cmp rax, rcx
    jl 1b
    ret

# Read As much bytes as passed by the first arg
# Touch 2KB over and over
# Each iteration reads 2048 bytes (32 * 64)
touch_2KB_64_loads:
    xor rax, rax
    xor r8, r8  # Offset
.align 64
1:
    add rax, 2048  # Count 2048 bytes are read
    and r8, 2047   # 2^11 - 1 mask
    mov r9, r8     # Offset + address will be stored here
    add r9, rdx    # Add the address to the offset
    add r8, 2048   # Increase the offset for next iteration
    vmovdqa ymm0, [r9 + 0   ]
    vmovdqa ymm1, [r9 + 32  ]
    vmovdqa ymm2, [r9 + 64  ]
    vmovdqa ymm3, [r9 + 96  ]
    vmovdqa ymm0, [r9 + 128 ]
    vmovdqa ymm1, [r9 + 160 ]
    vmovdqa ymm2, [r9 + 192 ]
    vmovdqa ymm3, [r9 + 224 ]
    vmovdqa ymm0, [r9 + 256 ]
    vmovdqa ymm1, [r9 + 288 ]
    vmovdqa ymm2, [r9 + 320 ]
    vmovdqa ymm3, [r9 + 352 ]
    vmovdqa ymm0, [r9 + 384 ]
    vmovdqa ymm1, [r9 + 416 ]
    vmovdqa ymm2, [r9 + 448 ]
    vmovdqa ymm3, [r9 + 480 ]
    vmovdqa ymm0, [r9 + 512 ]
    vmovdqa ymm1, [r9 + 544 ]
    vmovdqa ymm2, [r9 + 576 ]
    vmovdqa ymm3, [r9 + 608 ]
    vmovdqa ymm0, [r9 + 640 ]
    vmovdqa ymm1, [r9 + 672 ]
    vmovdqa ymm2, [r9 + 704 ]
    vmovdqa ymm3, [r9 + 736 ]
    vmovdqa ymm0, [r9 + 768 ]
    vmovdqa ymm1, [r9 + 800 ]
    vmovdqa ymm2, [r9 + 832 ]
    vmovdqa ymm3, [r9 + 864 ]
    vmovdqa ymm0, [r9 + 896 ]
    vmovdqa ymm1, [r9 + 928 ]
    vmovdqa ymm2, [r9 + 960 ]
    vmovdqa ymm3, [r9 + 992 ]
    vmovdqa ymm0, [r9 + 1024]
    vmovdqa ymm1, [r9 + 1056]
    vmovdqa ymm2, [r9 + 1088]
    vmovdqa ymm3, [r9 + 1120]
    vmovdqa ymm0, [r9 + 1152]
    vmovdqa ymm1, [r9 + 1184]
    vmovdqa ymm2, [r9 + 1216]
    vmovdqa ymm3, [r9 + 1248]
    vmovdqa ymm0, [r9 + 1280]
    vmovdqa ymm1, [r9 + 1312]
    vmovdqa ymm2, [r9 + 1344]
    vmovdqa ymm3, [r9 + 1376]
    vmovdqa ymm0, [r9 + 1408]
    vmovdqa ymm1, [r9 + 1440]
    vmovdqa ymm2, [r9 + 1472]
    vmovdqa ymm3, [r9 + 1504]
    vmovdqa ymm0, [r9 + 1536]
    vmovdqa ymm1, [r9 + 1568]
    vmovdqa ymm2, [r9 + 1600]
    vmovdqa ymm3, [r9 + 1632]
    vmovdqa ymm0, [r9 + 1664]
    vmovdqa ymm1, [r9 + 1696]
    vmovdqa ymm2, [r9 + 1728]
    vmovdqa ymm3, [r9 + 1760]
    vmovdqa ymm0, [r9 + 1792]
    vmovdqa ymm1, [r9 + 1824]
    vmovdqa ymm2, [r9 + 1856]
    vmovdqa ymm3, [r9 + 1888]
    vmovdqa ymm0, [r9 + 1920]
    vmovdqa ymm1, [r9 + 1952]
    vmovdqa ymm2, [r9 + 1984]
    vmovdqa ymm3, [r9 + 2016]
    cmp rax, rcx
    jl 1b
    ret

# Read As much bytes as passed by the first arg
# Touch 4KB over and over
# Each iteration reads 128 bytes (32 * 4)
touch_4KB:
    xor rax, rax
    xor R8, R8  # Offset
.align 64
1:
    add rax, 128  # Count 128 bytes are read
    and R8, 4095  # 2^12 - 1 mask
    mov R9, R8    # Offset + address will be stored here
    add R9, rdx   # Add the address to the offset
    add R8, 128   # Increase the offset for next iteration
    vmovdqa ymm0, [R9 + 0 ]
    vmovdqa ymm1, [R9 + 32]
    vmovdqa ymm2, [R9 + 64]
    vmovdqa ymm3, [R9 + 96]
    cmp rax, rcx
    jl 1b
    ret

# Read As much bytes as passed by the first arg
# Touch 8KB over and over
# Each iteration reads 128 bytes (32 * 4)
touch_8KB:
    xor rax, rax
    xor R8, R8  # Offset
.align 64
1:
    add rax, 128  # Count 128 bytes are read
    and R8, 8191  # 2^13 - 1 mask
    mov R9, R8    # Offset + address will be stored here
    add R9, rdx   # Add the address to the offset
    add R8, 128   # Increase the offset for next iteration
    vmovdqa ymm0, [R9 + 0 ]
    vmovdqa ymm1, [R9 + 32]
    vmovdqa ymm2, [R9 + 64]
    vmovdqa ymm3, [R9 + 96]
    cmp rax, rcx
    jl 1b
    ret

# Read As much bytes as passed by the first arg
# Touch 16KB over and over
# Each iteration reads 128 bytes (32 * 4)
touch_16KB:
    xor rax, rax
    xor R8, R8  # Offset
.align 64
1:
    add rax, 128  # Count 128 bytes are read
    and R8, 16383 # 2^14 - 1 mask
    mov R9, R8    # Offset + address will be stored here
    add R9, rdx   # Add the address to the offset
    add R8, 128   # Increase the offset for next iteration
    vmovdqa ymm0, [R9 + 0 ]
    vmovdqa ymm1, [R9 + 32]
    vmovdqa ymm2, [R9 + 64]
    vmovdqa ymm3, [R9 + 96]
    cmp rax, rcx
    jl 1b
    ret

# Read As much bytes as passed by the first arg
# Touch 32KB over and over
# Each iteration reads 128 bytes (32 * 4)
touch_32KB:
    xor rax, rax
    xor R8, R8  # Offset
.align 64
1:
    add rax, 128  # Count 128 bytes are read
    and R8, 32767 # 2^15 - 1 mask
    mov R9, R8    # Offset + address will be stored here
    add R9, rdx   # Add the address to the offset
    add R8, 128   # Increase the offset for next iteration
    vmovdqa ymm0, [R9 + 0 ]
    vmovdqa ymm1, [R9 + 32]
    vmovdqa ymm2, [R9 + 64]
    vmovdqa ymm3, [R9 + 96]
    cmp rax, rcx
    jl 1b
    ret

# Read As much bytes as passed by the first arg
# Touch 64KB over and over
# Each iteration reads 128 bytes (32 * 4)
touch_64KB:
    xor rax, rax
    xor R8, R8  # Offset
.align 64
1:
    add rax, 128  # Count 128 bytes are read
    and R8, 65535 # 2^16 - 1 mask
    mov R9, R8    # Offset + address will be stored here
    add R9, rdx   # Add the address to the offset
    add R8, 128   # Increase the offset for next iteration
    vmovdqa ymm0, [R9 + 0 ]
    vmovdqa ymm1, [R9 + 32]
    vmovdqa ymm2, [R9 + 64]
    vmovdqa ymm3, [R9 + 96]
    cmp rax, rcx
    jl 1b
    ret

# Read As much bytes as passed by the first arg
# Touch 128KB over and over
# Each iteration reads 128 bytes (32 * 4)
touch_128KB:
    xor rax, rax
    xor R8, R8  # Offset
.align 64
1:
    add rax, 128   # Count 128 bytes are read
    and R8, 131071 # 2^17 - 1 mask
    mov R9, R8     # Offset + address will be stored here
    add R9, rdx    # Add the address to the offset
    add R8, 128    # Increase the offset for next iteration
    vmovdqa ymm0, [R9 + 0 ]
    vmovdqa ymm1, [R9 + 32]
    vmovdqa ymm2, [R9 + 64]
    vmovdqa ymm3, [R9 + 96]
    cmp rax, rcx
    jl 1b
    ret

# Read As much bytes as passed by the first arg
# Touch 256KB over and over
# Each iteration reads 128 bytes (32 * 4)
touch_256KB:
    xor rax, rax
    xor R8, R8  # Offset
.align 64
1:
    add rax, 128   # Count 128 bytes are read
    and R8, 262143 # 2^18 - 1 mask
    mov R9, R8     # Offset + address will be stored here
    add R9, rdx    # Add the address to the offset
    add R8, 128    # Increase the offset for next iteration
    vmovdqa ymm0, [R9 + 0 ]
    vmovdqa ymm1, [R9 + 32]
    vmovdqa ymm2, [R9 + 64]
    vmovdqa ymm3, [R9 + 96]
    cmp rax, rcx
    jl 1b
    ret

# Read As much bytes as passed by the first arg
# Touch 512KB over and over
# Each iteration reads 128 bytes (32 * 4)
touch_512KB:
    xor rax, rax
    xor R8, R8  # Offset
.align 64
1:
    add rax, 128   # Count 128 bytes are read
    and R8, 524287 # 2^19 - 1 mask
    mov R9, R8     # Offset + address will be stored here
    add R9, rdx    # Add the address to the offset
    add R8, 128    # Increase the offset for next iteration
    vmovdqa ymm0, [R9 + 0 ]
    vmovdqa ymm1, [R9 + 32]
    vmovdqa ymm2, [R9 + 64]
    vmovdqa ymm3, [R9 + 96]
    cmp rax, rcx
    jl 1b
    ret

# Read As much bytes as passed by the first arg
# Touch 1MB over and over
# Each iteration reads 128 bytes (32 * 4)
touch_1MB:
    xor rax, rax
    xor R8, R8  # Offset
.align 64
1:
    add rax, 128   # Count 128 bytes are read
    and R8, 1048575 # 2^20 - 1 mask
    mov R9, R8     # Offset + address will be stored here
    add R9, rdx    # Add the address to the offset
    add R8, 128    # Increase the offset for next iteration
    vmovdqa ymm0, [R9 + 0 ]
    vmovdqa ymm1, [R9 + 32]
    vmovdqa ymm2, [R9 + 64]
    vmovdqa ymm3, [R9 + 96]
    cmp rax, rcx
    jl 1b
    ret

# Read As much bytes as passed by the first arg
# Touch 2MB over and over
# Each iteration reads 128 bytes (32 * 4)
touch_2MB:
    xor rax, rax
    xor R8, R8  # Offset
.align 64
1:
    add rax, 128   # Count 128 bytes are read
    and R8, 2097151 # 2^21 - 1 mask
    mov R9, R8     # Offset + address will be stored here
    add R9, rdx    # Add the address to the offset
    add R8, 128    # Increase the offset for next iteration
    vmovdqa ymm0, [R9 + 0 ]
    vmovdqa ymm1, [R9 + 32]
    vmovdqa ymm2, [R9 + 64]
    vmovdqa ymm3, [R9 + 96]
    cmp rax, rcx
    jl 1b
    ret

# Read As much bytes as passed by the first arg
# Touch 4MB over and over
# Each iteration reads 128 bytes (32 * 4)
touch_4MB:
    xor rax, rax
    xor R8, R8  # Offset
.align 64
1:
    add rax, 128   # Count 128 bytes are read
    and R8, 4194303 # 2^22 - 1 mask
    mov R9, R8     # Offset + address will be stored here
    add R9, rdx    # Add the address to the offset
    add R8, 128    # Increase the offset for next iteration
    vmovdqa ymm0, [R9 + 0 ]
    vmovdqa ymm1, [R9 + 32]
    vmovdqa ymm2, [R9 + 64]
    vmovdqa ymm3, [R9 + 96]
    cmp rax, rcx
    jl 1b
    ret

# Read As much bytes as passed by the first arg
# Touch 8MB over and over
# Each iteration reads 128 bytes (32 * 4)
touch_8MB:
    xor rax, rax
    xor R8, R8  # Offset
.align 64
1:
    add rax, 128   # Count 128 bytes are read
    and R8, 8388607 # 2^23 - 1 mask
    mov R9, R8     # Offset + address will be stored here
    add R9, rdx    # Add the address to the offset
    add R8, 128    # Increase the offset for next iteration
    vmovdqa ymm0, [R9 + 0 ]
    vmovdqa ymm1, [R9 + 32]
    vmovdqa ymm2, [R9 + 64]
    vmovdqa ymm3, [R9 + 96]
    cmp rax, rcx
    jl 1b
    ret

# Read As much bytes as passed by the first arg
# Touch 16MB over and over
# Each iteration reads 128 bytes (32 * 4)
touch_16MB:
    xor rax, rax
    xor R8, R8  # Offset
.align 64
1:
    add rax, 128   # Count 128 bytes are read
    and R8, 16777215 # 2^24 - 1 mask
    mov R9, R8     # Offset + address will be stored here
    add R9, rdx    # Add the address to the offset
    add R8, 128    # Increase the offset for next iteration
    vmovdqa ymm0, [R9 + 0 ]
    vmovdqa ymm1, [R9 + 32]
    vmovdqa ymm2, [R9 + 64]
    vmovdqa ymm3, [R9 + 96]
    cmp rax, rcx
    jl 1b
    ret

# Read As much bytes as passed by the first arg
# Touch 32MB over and over
# Each iteration reads 128 bytes (32 * 4)
touch_32MB:
    xor rax, rax
    xor R8, R8  # Offset
.align 64
1:
    add rax, 128   # Count 128 bytes are read
    and R8, 33554431 # 2^25 - 1 mask
    mov R9, R8     # Offset + address will be stored here
    add R9, rdx    # Add the address to the offset
    add R8, 128    # Increase the offset for next iteration
    vmovdqa ymm0, [R9 + 0 ]
    vmovdqa ymm1, [R9 + 32]
    vmovdqa ymm2, [R9 + 64]
    vmovdqa ymm3, [R9 + 96]
    cmp rax, rcx
    jl 1b
    ret

# Read As much bytes as passed by the first arg
# Touch 64MB over and over
# Each iteration reads 128 bytes (32 * 4)
touch_64MB:
    xor rax, rax
    xor R8, R8  # Offset
.align 64
1:
    add rax, 128   # Count 128 bytes are read
    and R8, 67108863 # 2^26 - 1 mask
    mov R9, R8     # Offset + address will be stored here
    add R9, rdx    # Add the address to the offset
    add R8, 128    # Increase the offset for next iteration
    vmovdqa ymm0, [R9 + 0 ]
    vmovdqa ymm1, [R9 + 32]
    vmovdqa ymm2, [R9 + 64]
    vmovdqa ymm3, [R9 + 96]
    cmp rax, rcx
    jl 1b
    ret

# Read As much bytes as passed by the first arg
# Touch 128MB over and over
# Each iteration reads 128 bytes (32 * 4)
touch_128MB:
    xor rax, rax
    xor R8, R8  # Offset
.align 64
1:
    add rax, 128   # Count 128 bytes are read
    and R8, 134217727 # 2^27 - 1 mask
    mov R9, R8     # Offset + address will be stored here
    add R9, rdx    # Add the address to the offset
    add R8, 128    # Increase the offset for next iteration
    vmovdqa ymm0, [R9 + 0 ]
    vmovdqa ymm1, [R9 + 32]
    vmovdqa ymm2, [R9 + 64]
    vmovdqa ymm3, [R9 + 96]
    cmp rax, rcx
    jl 1b
    ret

# Read As much bytes as passed by the first arg
# Touch 256MB over and over
# Each iteration reads 128 bytes (32 * 4)
touch_256MB:
    xor rax, rax
    xor R8, R8  # Offset
.align 64
1:
    add rax, 128   # Count 128 bytes are read
    and R8, 268435455 # 2^28 - 1 mask
    mov R9, R8     # Offset + address will be stored here
    add R9, rdx    # Add the address to the offset
    add R8, 128    # Increase the offset for next iteration
    vmovdqa ymm0, [R9 + 0 ]
    vmovdqa ymm1, [R9 + 32]
    vmovdqa ymm2, [R9 + 64]
    vmovdqa ymm3, [R9 + 96]
    cmp rax, rcx
    jl 1b
    ret

# Read As much bytes as passed by the first arg
# Touch 512MB over and over
# Each iteration reads 128 bytes (32 * 4)
touch_512MB:
    xor rax, rax
    xor R8, R8  # Offset
.align 64
1:
    add rax, 128   # Count 128 bytes are read
    and R8, 536870911 # 2^29 - 1 mask
    mov R9, R8     # Offset + address will be stored here
    add R9, rdx    # Add the address to the offset
    add R8, 128    # Increase the offset for next iteration
    vmovdqa ymm0, [R9 + 0 ]
    vmovdqa ymm1, [R9 + 32]
    vmovdqa ymm2, [R9 + 64]
    vmovdqa ymm3, [R9 + 96]
    cmp rax, rcx
    jl 1b
    ret

# Read As much bytes as passed by the first arg
# Touch 1GB over and over
# Each iteration reads 128 bytes (32 * 4)
touch_1GB:
    xor rax, rax
    xor R8, R8  # Offset
.align 64
1:
    add rax, 128   # Count 128 bytes are read
    and R8, 1073741823 # 2^30 - 1 mask
    mov R9, R8     # Offset + address will be stored here
    add R9, rdx    # Add the address to the offset
    add R8, 128    # Increase the offset for next iteration
    vmovdqa ymm0, [R9 + 0 ]
    vmovdqa ymm1, [R9 + 32]
    vmovdqa ymm2, [R9 + 64]
    vmovdqa ymm3, [R9 + 96]
    cmp rax, rcx
    jl 1b
    ret