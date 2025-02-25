.section ".text.boot"
.global _start

_start:
    // Obtenir l'ID du cœur
    mrs x1, mpidr_el1
    and x1, x1, #3
    cbz x1, primary_cpu    // Si cœur 0, continuer
hang:                      // Sinon, bloquer les autres cœurs
    b hang

primary_cpu:
    // Configurer la pile
    ldr x1, =_stack_top
    mov sp, x1

    // Effacer la section BSS
    ldr x1, =__bss_start
    ldr x2, =__bss_end
bss_loop:
    cmp x1, x2
    b.ge bss_done
    str xzr, [x1], #8
    b bss_loop

bss_done:
    // Sauter au code du kernel
    ldr x1, =kernel_main
    br x1

// Espace pour la pile
.section ".bss"
.align 16
stack:
    .skip 0x1000    // 4KB de pile
_stack_top:
