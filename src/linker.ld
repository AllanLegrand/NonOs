ENTRY(_start)

SECTIONS {
    . = 0x40080000;

    .text.boot : {
        *(.text.boot)
    }

    .text : {
        *(.text)
    }

    .rodata : {
        *(.rodata)
    }

    .data : {
        *(.data)
    }

    __bss_start = .;
    .bss : {
        *(.bss)
    }
    __bss_end = .;

    . = ALIGN(16);
}

/* Attributs explicites pour les segments LOAD */
PHDRS {
	/* RX: Read + Execute (4 + 1) */
    text PT_LOAD FLAGS(5);
	/* R: Read-only (4) */
    rodata PT_LOAD FLAGS(4);
	/* RW: Read + Write (4 + 2) */
    data PT_LOAD FLAGS(6);
}

/* Associer les sections aux segments */
SECTIONS {
    .text.boot : { *(.text.boot) } :text
    .text : { *(.text) } :text
    .rodata : { *(.rodata) } :rodata
    .data : { *(.data) } :data
    .bss : { *(.bss) } :data
}
