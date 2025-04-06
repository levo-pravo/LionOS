ASM=nasm
BOOT_DIR=boot
BUILD_DIR=build

$(BUILD_DIR)/main_floppy.img: $(BUILD_DIR)/boot.bin
	cp $(BUILD_DIR)/boot.bin $(BUILD_DIR)/main_floppy.img
	truncate -s 1440k $(BUILD_DIR)/main_floppy.img

$(BUILD_DIR)/boot.bin: $(BOOT_DIR)/boot.asm
	$(ASM) $(BOOT_DIR)/boot.asm -f bin -o $(BUILD_DIR)/boot.bin
