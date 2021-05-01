
TOOLCHAIN = ../lc87-toolchain

.PHONY: clean

CC = $(TOOLCHAIN)/bin/cc87.exe
AS = $(TOOLCHAIN)/bin/as87.exe
LKR = $(TOOLCHAIN)/bin/l87.exe

all: fibonacci.hex fibonacci.bin fibonacci.ghd.map

fibonacci.hex: fibonacci.c
	$(CC) -M -Tc-Bp -v -tmp -s -g -ihex $< -o $@ 
	
fibonacci.map: fibonacci.hex

%.obj: %.asm
	$(CC) -c -v -nolib -o $@ $<

%.hex: %.obj
	$(LKR) -M -lcs -lrts -v $< -o$@:ihex 2>&1 | cat

%.map: %.hex

%.bin: %.hex
	objcopy -I ihex -O binary $< $@

# a map file that Ghidra can import
%.ghd.map: %.map
	$(TOOLCHAIN)/script/map2ghidra.sh $< | tee $@


clean:
	rm -f ./*.src
	rm -f ./*.obj
	rm -f ./*.bin
	rm -f ./*.map
	rm -f ./*.mdf
	rm -f ./*.hex