# Project setup
PROJ        = addressable
BUILD       = .build
CONSTRAINTS = constraints
DEVICE      = 8k
FOOTPRINT   = ct256
OS         := $(shell uname -s)

# Files
VHDL_FILES    = src/vhdl/top.vhdl
VERILOG_FILES = src/verilog/top.v

# Synthesis commands
VHDL_SYNTHESIS    := yosys -m ghdl -p "ghdl $(VHDL_FILES) -e top; synth_ice40 -blif $(BUILD)/$(PROJ).blif -json $(BUILD)/$(PROJ).json"
VERILOG_SYNTHESIS := yosys -p "synth_ice40 -top top -blif $(BUILD)/$(PROJ).blif -json $(BUILD)/$(PROJ).json" $(VERILOG_FILES)

ifeq ($(OS), Linux)
	synthesis := $(VHDL_SYNTHESIS)
else
	synthesis := $(VERILOG_SYNTHESIS)
endif

.PHONY: all clean burn timing

all $(BUILD)/$(PROJ).asc $(BUILD)/$(PROJ).bin:
	# if build folder doesn't exist, create it
	mkdir -p $(BUILD)
	# synthesize using Yosys
	$(synthesis)
	# Place and route using nextpnr
	nextpnr-ice40 --hx$(DEVICE) --package $(FOOTPRINT) --json $(BUILD)/$(PROJ).json --pcf $(CONSTRAINTS)/pinmap.pcf --asc $(BUILD)/$(PROJ).asc
	# Convert to bitstream using IcePack
	icepack $(BUILD)/$(PROJ).asc $(BUILD)/$(PROJ).bin

burn: $(BUILD)/$(PROJ).bin
	iceprog $(BUILD)/$(PROJ).bin

timing: $(BUILD)/$(PROJ).asc
	icetime -tmd hx$(DEVICE) $(BUILD)/$(PROJ).asc

clean:
	rm build/*
