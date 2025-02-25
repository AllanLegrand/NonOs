TARGET=aarch64-freestanding-none
ZIG=zig

# Compilateurs
AS_MAC=aarch64-elf-as
LD_MAC=aarch64-elf-ld
OBJCOPY_MAC=aarch64-elf-objcopy

AS_LINUX=aarch64-linux-gnu-as
LD_LINUX=aarch64-linux-gnu-ld
OBJCOPY_LINUX=aarch64-linux-gnu-objcopy

# Répertoires
SRC=src
BUILD=build
LOG=log

# Fichiers
BOOT_SRC=$(SRC)/boot.s
KERNEL_SRC=$(SRC)/kernel.zig
LINKER_SCRIPT=$(SRC)/linker.ld

BOOT_OBJ=$(BUILD)/boot.o
KERNEL_OBJ=$(BUILD)/kernel.o
KERNEL_ELF=$(BUILD)/kernel.elf
KERNEL_BIN=$(BUILD)/kernel.bin
QEMU_LOG=$(LOG)/qemu_debug.log

all: linux

macos: clean prepare $(KERNEL_BIN)
	qemu-system-aarch64 \
		-M virt \
		-cpu cortex-a53 \
		-m 1024 \
		-kernel $(KERNEL_BIN) \
		-nographic \
		-d in_asm,int 2> $(QEMU_LOG)

linux: clean prepare $(KERNEL_BIN)
	qemu-system-aarch64 \
		-M virt \
		-cpu cortex-a53 \
		-m 1024 \
		-kernel $(KERNEL_BIN) \
		-display default

prepare:
	@mkdir -p $(BUILD)
	@mkdir -p $(LOG)

$(BOOT_OBJ): $(BOOT_SRC)
	$(AS_MAC) -o $(BOOT_OBJ) $(BOOT_SRC)

$(KERNEL_OBJ): $(KERNEL_SRC)
	$(ZIG) build-obj $(KERNEL_SRC) -O ReleaseSmall --name kernel -target $(TARGET)
	mv kernel.o $(KERNEL_OBJ)
	rm kernel.o.O

$(KERNEL_ELF): $(BOOT_OBJ) $(KERNEL_OBJ) $(LINKER_SCRIPT)
	$(LD_MAC) -T $(LINKER_SCRIPT) -o $(KERNEL_ELF) $(BOOT_OBJ) $(KERNEL_OBJ)

$(KERNEL_BIN): $(KERNEL_ELF)
	$(OBJCOPY_MAC) -O binary $(KERNEL_ELF) $(KERNEL_BIN)

clean:
	rm -rf $(BUILD)
	rm -rf $(LOG)
