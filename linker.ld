ENTRY(_start)

SECTIONS {
	. = 0x80000;    /* Adresse de chargement typique pour aarch64 */

	.text.boot : { *(.text.boot) }
	.text : { *(.text) }
	.rodata : { *(.rodata) }
	.data : { *(.data) }

	__bss_start = .;
	.bss : { *(.bss) }
	__bss_end = .;
}
