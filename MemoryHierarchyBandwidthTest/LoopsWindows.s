.intel_syntax noprefix

.globl touch_2KB
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
    xor R8, R8  # Offset
.align 64
1:
    add rax, 128  # Count 128 bytes are read
    and R8, 2047  # 2^11 - 1 mask
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