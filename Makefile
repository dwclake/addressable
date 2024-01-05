# Project setup
PROJ      = addressable
BUILD     = ./build
DEVICE    = 8k
FOOTPRINT = ct256

# Files
FILES = src/top.vhdl

.PHONY: all clean burn timing

all $(BUILD)/$(PROJ).asc $(BUILD)/$(PROJ).bin:
	# if build folder doesn't exist, create it
	mkdir -p $(BUILD)
	# synthesize using Yosys
	yosys -m ghdl -p "ghdl $(FILES) -e top; synth_ice40 -blif $(BUILD)/$(PROJ).blif -json $(BUILD)/$(PROJ).json"
	# Place and route using nextpnr
	nextpnr-ice40 --hx$(DEVICE) --json build/$(PROJ).json --pcf constraints/pinmap.pcf --asc build/$(PROJ).asc
	# Convert to bitstream using IcePack
	icepack $(BUILD)/$(PROJ).asc $(BUILD)/$(PROJ).bin

burn: $(BUILD)/$(PROJ).bin
	iceprog $(BUILD)/$(PROJ).bin

timing: $(BUILD)/$(PROJ).asc
	icetime -tmd hx$(DEVICE) $(BUILD)/$(PROJ).asc

clean:
	rm build/*
