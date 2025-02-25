# Compilation du bootloader
/opt/homebrew/opt/aarch64-elf-binutils/bin/aarch64-elf-as -o boot.o boot.s
# Compilation du kernel
zig build-obj kernel.zig -O ReleaseSmall --name kernel -target aarch64-freestanding-none
# Liaison
/opt/homebrew/opt/aarch64-elf-binutils/bin/aarch64-elf-ld -T linker.ld -o kernel.elf boot.o kernel.o
# Conversion en binaire
/opt/homebrew/opt/aarch64-elf-binutils/bin/aarch64-elf-objcopy -O binary kernel.elf kernel.bin
# Qemu
qemu-system-aarch64 \
	-M virt \
	-cpu cortex-a53 \
	-m 1024 \
	-drive if=pflash,format=raw,readonly=on,file=/opt/homebrew/share/qemu/edk2-aarch64-code.fd \
	-kernel kernel.bin \
	-nographic
