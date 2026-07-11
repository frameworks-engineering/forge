ifneq ($(DEVKITPRO),)
    export DEVKITARM ?= $(DEVKITPRO)/devkitARM
else
    $(error "DEVKITPRO not set. Please install devkitPro and set the environment variable.")
endif

include $(DEVKITARM)/ds_rules

TARGET := forge
BUILD := build
SOURCES := source
INCLUDES := include

CFILES := $(foreach dir,$(SOURCES),$(wildcard $(dir)/*.c))
CPPFILES := $(foreach dir,$(SOURCES),$(wildcard $(dir)/*.cpp))
SFILES := $(foreach dir,$(SOURCES),$(wildcard $(dir)/*.s))
BINFILES := $(foreach dir,$(DATA),$(wildcard $(dir)/*.*))

ARCH := -mthumb -mthumb-interwork -march=armv5te -mtune=arm946e-s
CFLAGS := -g -O2 -Wall -ffast-math $(ARCH)
CFLAGS += -I$(LIBNDS)/include
CXXFLAGS := $(CFLAGS) -fno-rtti -fno-exceptions
ASFLAGS := -g $(ARCH)
LDFLAGS := -specs=ds_arm9.specs -g $(ARCH) -Wl,-Map,$(TARGET).map

LIBS := -lnds9 -lmm9

.PHONY: all clean

all: $(TARGET).nds

$(TARGET).nds: $(TARGET).arm9
	ndstool -c $@ -9 $< -b $(TARGET).bmp "Forge;Frameworks Eng."

$(TARGET).arm9: $(BUILD)/$(TARGET).elf
	arm-none-eabi-objcopy -O binary $< $@

$(BUILD)/$(TARGET).elf: $(CPPFILES) $(CFILES) $(SFILES)
	@mkdir -p $(BUILD)
	$(CXX) $(CXXFLAGS) $(CPPFILES) -o $@ $(LDFLAGS) $(LIBS)

clean:
	rm -rf $(BUILD) $(TARGET).arm9 $(TARGET).nds
