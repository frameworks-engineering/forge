TARGET := forge
SOURCES := source
INCLUDES := include
GRAPHICS := graphics
AUDIO := audio

export DEVKITPRO ?= /opt/devkitpro
export DEVKITARM ?= $(DEVKITPRO)/devkitARM
include $(DEVKITARM)/ds_rules

BUILD := build
ARM9_SOURCES := $(SOURCES)
ARM7_SOURCES :=

.PHONY: all clean

all: $(TARGET).nds

$(TARGET).nds: $(TARGET).arm9
	ndstool -c $@ -9 $< -b $(TARGET).bmp "Forge;Frameworks Eng."

$(TARGET).arm9: $(BUILD)/$(TARGET).elf
	arm-none-eabi-objcopy -O binary $< $@

$(BUILD)/$(TARGET).elf: $(SOURCES)/main.cpp
	mkdir -p $(BUILD)
	arm-none-eabi-gcc -mthumb -mthumb-interwork -march=armv5te -mtune=arm946e-s -O2 \
		-fomit-frame-pointer -ffast-math -I$(DEVKITPRO)/libnds/include \
		-DARM9 -c $< -o $(BUILD)/main.o
	arm-none-eabi-gcc -mthumb -mthumb-interwork -march=armv5te -mtune=arm946e-s -O2 \
		$(BUILD)/main.o -L$(DEVKITPRO)/libnds/lib -lnds9 -o $@

clean:
	rm -rf $(BUILD) $(TARGET).arm9 $(TARGET).nds
