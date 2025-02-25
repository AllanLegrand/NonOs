const uart_base: usize = 0x09000000; // Adresse typique UART pour QEMU virt

// Fonction pour écrire un caractère sur l'UART
fn putChar(c: u8) void {
    const uart = @as(*volatile u8, @ptrFromInt(uart_base));
    uart.* = c;
}

// Fonction pour écrire une chaîne
fn putString(str: []const u8) void {
    for (str) |c| {
        putChar(c);
    }
}

export fn kernel_main() noreturn {
    putString("salut\n");
    while (true) {}
}
