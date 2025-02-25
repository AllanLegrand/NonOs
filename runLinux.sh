# Compilation du bootloader
aarch64-linux-gnu-as -o boot.o boot.s
# Compilation du kernel
zig build-obj kernel.zig -O ReleaseSmall --name kernel -target aarch64-freestanding-none
# Liaison
aarch64-linux-gnu-ld -T linker.ld -o kernel.elf boot.o kernel.o
# Conversion en binaire
aarch64-linux-gnu-objcopy -O binary kernel.elf kernel.bin
# Qemu
qemu-system-aarch64 \
	-M virt \
	-cpu cortex-a53 \
	-m 1024 \
	-kernel kernel.bin \
	-display default
