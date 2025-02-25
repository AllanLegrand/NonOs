.section ".text.boot"
.global _start

_start:
    mrs x1, mpidr_el1
    and x1, x1, #3
    cbz x1, primary_cpu
hang:
    b hang

primary_cpu:
    ldr x1, =_stack_top
    mov sp, x1

	// Adresse UART
    mov x0, #0x09000000
    adr x2, boot_msg
print_loop:
	// Charger un caractère et incrémenter x2
    ldrb w1, [x2], #1
    cbz w1, print_done
	// Écrire le caractère sur l'UART
    strb w1, [x0] 
    b print_loop 

print_done:
    ldr x1, =kernel_main
    br x1

.section ".data"
boot_msg:
    .ascii "Booting\n"
    .byte 0 

.section ".bss"
.align 16
stack:
	// 4KB de pile
    .skip 0x1000 
_stack_top:
