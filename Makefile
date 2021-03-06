# Automatically generate lists of sources using wildcards.
C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h)
S_SOURCES = $(shell find . -name "*.s")
# S_OBJECTS = $(patsubst %.s, %.o, $(S_SOURCES))

#Convert the *.c filename to *.o
OBJ = ${C_SOURCES:.c=.o}
S_OBJECTS = ${S_SOURCES:.s=.o}

# Defauil build target
all: os-image

bochs: all
		bochs

os-image: new_boot_sect.bin kernel.bin
		cat $^ > os-image

kernel.bin: kernel/kernel_entry.o ${OBJ} ${S_OBJECTS}
		ld -o $@ -melf_i386 -Ttext 0x1000 $^ --oformat binary

%.o: %.c ${HEADERS}
		gcc -Wall -m32 -ffreestanding -I include -c $< -o $@

%.o: %.s
		nasm $< -f elf32 -o $@

%.o: %.asm
		nasm $< -f elf32 -o $@

new_boot_sect.bin: new_boot_sect.asm
		nasm $< -f bin -o $@

%.bin: %.o
		nasm $< -f bin -o $@

clean:
		rm -fr *.bin *.dis *.o os-image
		rm -fr kernel/*.o boot/*.bin drivers/*.o 
		
