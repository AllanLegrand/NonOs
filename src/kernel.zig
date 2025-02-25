const uart_base: usize = 0x09000000;

fn putChar(c: u8) void {
    const uart: *volatile u8 = @ptrFromInt(uart_base);
    uart.* = c;
}

fn putString(str: []const u8) void {
    for (str) |c| {
        putChar(c);
    }
}

export fn kernel_main() noreturn {
    putString("Démarrage du kernel\n");
    while (true) {}
}
