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

CPPFILES := $(wildcard $(SOURCES)/*.cpp)
CFILES := $(wildcard $(SOURCES)/*.c)
SFILES := $(wildcard $(SOURCES)/*.s)
BINFILES := $(wildcard $(SOURCES)/*.bin)

CFLAGS += -DARM9 -I$(LIBNDS)/include
CXXFLAGS += -DARM9 -I$(LIBNDS)/include -fno-rtti -fno-exceptions
LDFLAGS += -L$(LIBNDS)/lib
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
