#---------------------------------------------------------------------------------
# Clear the implicit built in rules
#---------------------------------------------------------------------------------
.SUFFIXES:
#---------------------------------------------------------------------------------
ifeq ($(strip $(DEVKITARM)),)
$(error "Please set DEVKITARM in your environment")
endif

include $(DEVKITARM)/ds_rules

#---------------------------------------------------------------------------------
# TARGET is the name of the output
# BUILD is the directory where object files & intermediate files will be placed
# SOURCES is a list of directories containing source code
# INCLUDES is a list of directories containing extra header files
# DATA is a list of directories containing binary files embedded using bin2o
# GRAPHICS is a list of directories containing image files to be converted
# AUDIO is a list of directories containing audio to be converted
#---------------------------------------------------------------------------------
TARGET   := forge
BUILD    := build
SOURCES  := source
INCLUDES := include
DATA     := data
GRAPHICS := graphics
AUDIO    := audio

#---------------------------------------------------------------------------------
# options for code generation
#---------------------------------------------------------------------------------
ARCH := -mthumb -mthumb-interwork -march=armv5te -mtune=arm946e-s

CFLAGS   := -g -O2 -Wall $(ARCH)
CFLAGS   += $(INCLUDE) -DARM9
CXXFLAGS := $(CFLAGS) -fno-rtti -fno-exceptions
ASFLAGS  := -g $(ARCH)
LDFLAGS  := -specs=ds_arm9.specs -g $(ARCH) -Wl,-Map,$(TARGET).map

#---------------------------------------------------------------------------------
# any extra libraries we wish to link with the project (order is important)
#---------------------------------------------------------------------------------
LIBS := -lnds9 -lmm9

#---------------------------------------------------------------------------------
# list of directories containing libraries, this must be the top level linking
# directory
#---------------------------------------------------------------------------------
LIBDIRS := $(LIBNDS)

#---------------------------------------------------------------------------------
# no real need to edit anything past this point unless you need to add additional
# rules for different file extensions
#---------------------------------------------------------------------------------
ifneq ($(BUILD),$(notdir $(CURDIR)))
#---------------------------------------------------------------------------------

export OUTPUT := $(CURDIR)/$(TARGET)

export VPATH := $(foreach dir,$(SOURCES),$(CURDIR)/$(dir)) \
                $(foreach dir,$(DATA),$(CURDIR)/$(dir)) \
                $(foreach dir,$(GRAPHICS),$(CURDIR)/$(dir))

export DEPSDIR := $(CURDIR)/$(BUILD)

#---------------------------------------------------------------------------------
# automatically build a list of object files from our source directories
#---------------------------------------------------------------------------------
CFILES      := $(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.c)))
CPPFILES    := $(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.cpp)))
SFILES      := $(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.s)))
BINFILES    := $(foreach dir,$(DATA),$(notdir $(wildcard $(dir)/*.*)))
PNGFILES    := $(foreach dir,$(GRAPHICS),$(notdir $(wildcard $(dir)/*.png)))
BMPFILES    := $(foreach dir,$(GRAPHICS),$(notdir $(wildcard $(dir)/*.bmp)))
WAVFILES    := $(foreach dir,$(AUDIO),$(notdir $(wildcard $(dir)/*.wav)))
MODFILES    := $(foreach dir,$(AUDIO),$(notdir $(wildcard $(dir)/*.mod)))
XMFILES     := $(foreach dir,$(AUDIO),$(notdir $(wildcard $(dir)/*.xm)))
ITFILES     := $(foreach dir,$(AUDIO),$(notdir $(wildcard $(dir)/*.it)))
S3MFILES    := $(foreach dir,$(AUDIO),$(notdir $(wildcard $(dir)/*.s3m)))

#---------------------------------------------------------------------------------
# use CXX for linking C++ projects, CC for standard C
#---------------------------------------------------------------------------------
ifeq ($(strip $(CPPFILES)),)
#---------------------------------------------------------------------------------
	export LD := $(CC)
#---------------------------------------------------------------------------------
else
#---------------------------------------------------------------------------------
	export LD := $(CXX)
#---------------------------------------------------------------------------------
endif
#---------------------------------------------------------------------------------

export OFILES_BIN := $(addsuffix .o,$(BINFILES)) \
                     $(PNGFILES:.png=.o) $(BMPFILES:.bmp=.o) \
                     $(WAVFILES:.wav=.o) $(MODFILES:.mod=.o) \
                     $(XMFILES:.xm=.o) $(ITFILES:.it=.o) $(S3MFILES:.s3m=.o)

export OFILES_SOURCES := $(CPPFILES:.cpp=.o) $(CFILES:.c=.o) $(SFILES:.s=.o)

export OFILES := $(OFILES_BIN) $(OFILES_SOURCES)

export HFILES := $(addsuffix .h,$(subst .,,$(BINFILES))) \
                 $(PNGFILES:.png=.h) $(BMPFILES:.bmp=.h)

export INCLUDE := $(foreach dir,$(INCLUDES),-I$(CURDIR)/$(dir)) \
                  $(foreach dir,$(LIBDIRS),-I$(dir)/include) \
                  -I$(CURDIR)/$(BUILD)

export LIBPATHS := $(foreach dir,$(LIBDIRS),-L$(dir)/lib)

.PHONY: $(BUILD) clean all

#---------------------------------------------------------------------------------
all: $(BUILD)

$(BUILD):
	@[ -d $@ ] || mkdir -p $@
	@$(MAKE) --no-print-directory -C $(BUILD) -f $(CURDIR)/Makefile

#---------------------------------------------------------------------------------
clean:
	@echo clean ...
	@rm -fr $(BUILD) $(TARGET).arm9 $(TARGET).nds


#---------------------------------------------------------------------------------
else

#---------------------------------------------------------------------------------
# main targets
#---------------------------------------------------------------------------------
$(OUTPUT).nds: $(OUTPUT).arm9
$(OUTPUT).arm9: $(OUTPUT).elf

$(OUTPUT).elf: $(OFILES)

#---------------------------------------------------------------------------------
# rule to build .elf from .o files
#---------------------------------------------------------------------------------
%.elf: $(OFILES)
	$(LD) $(LDFLAGS) $(OFILES) $(LIBPATHS) $(LIBS) -o $@

#---------------------------------------------------------------------------------
# The rule to create the .nds file from the .arm9
#---------------------------------------------------------------------------------
%.nds: %.arm9
	ndstool -c $@ -9 $< -b $(OUTPUT).bmp "Forge;Frameworks Eng."

#---------------------------------------------------------------------------------
# This rule links in binary data with the .bin extension
#---------------------------------------------------------------------------------
%.bin.o : %.bin
#---------------------------------------------------------------------------------
	@echo $(notdir $<)
	$(bin2o)

#---------------------------------------------------------------------------------
# rules for assembling .s files
#---------------------------------------------------------------------------------
%.s.o : %.s
	$(AS) $(ASFLAGS) -o $@ $<

#---------------------------------------------------------------------------------
# rules for compiling .c files
#---------------------------------------------------------------------------------
%.c.o : %.c
	$(CC) $(CFLAGS) -c $< -o $@

#---------------------------------------------------------------------------------
# rules for compiling .cpp files
#---------------------------------------------------------------------------------
%.cpp.o : %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

#---------------------------------------------------------------------------------
# rules for converting .png to .o and .h
#---------------------------------------------------------------------------------
%.png.o %.png.h : %.png
#---------------------------------------------------------------------------------
	$(GFXCONV) -s $< -o $(basename $@).o -h $(basename $@).h

#---------------------------------------------------------------------------------
# rules for converting .bmp to .o and .h
#---------------------------------------------------------------------------------
%.bmp.o %.bmp.h : %.bmp
#---------------------------------------------------------------------------------
	$(GFXCONV) -s $< -o $(basename $@).o -h $(basename $@).h

#---------------------------------------------------------------------------------
# rules for converting .wav to .o and .h
#---------------------------------------------------------------------------------
%.wav.o %.wav.h : %.wav
#---------------------------------------------------------------------------------
	$(WAVCONV) $< $(basename $@).s
	$(AS) $(ASFLAGS) -o $@ $(basename $@).s

#---------------------------------------------------------------------------------
# rules for converting .mod to .o and .h
#---------------------------------------------------------------------------------
%.mod.o %.mod.h : %.mod
#---------------------------------------------------------------------------------
	$(MODCONV) $< $(basename $@).s
	$(AS) $(ASFLAGS) -o $@ $(basename $@).s

#---------------------------------------------------------------------------------
# rules for converting .xm to .o and .h
#---------------------------------------------------------------------------------
%.xm.o %.xm.h : %.xm
#---------------------------------------------------------------------------------
	$(XM2MOD) $< $(basename $@).mod
	$(MODCONV) $(basename $@).mod $(basename $@).s
	$(AS) $(ASFLAGS) -o $@ $(basename $@).s

#---------------------------------------------------------------------------------
# rules for converting .it to .o and .h
#---------------------------------------------------------------------------------
%.it.o %.it.h : %.it
#---------------------------------------------------------------------------------
	$(IT2MOD) $< $(basename $@).mod
	$(MODCONV) $(basename $@).mod $(basename $@).s
	$(AS) $(ASFLAGS) -o $@ $(basename $@).s

#---------------------------------------------------------------------------------
# rules for converting .s3m to .o and .h
#---------------------------------------------------------------------------------
%.s3m.o %.s3m.h : %.s3m
#---------------------------------------------------------------------------------
	$(S3M2MOD) $< $(basename $@).mod
	$(MODCONV) $(basename $@).mod $(basename $@).s
	$(AS) $(ASFLAGS) -o $@ $(basename $@).s

#---------------------------------------------------------------------------------
# Generate assembly from .png for GRIT
#---------------------------------------------------------------------------------
%.s %.h : %.png
#---------------------------------------------------------------------------------
	$(GFXCONV) -s $< -o $(basename $@).s -h $(basename $@).h


#---------------------------------------------------------------------------------
endif
#---------------------------------------------------------------------------------
