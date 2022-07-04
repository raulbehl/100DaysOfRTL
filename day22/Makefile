DAY  = day22
TIME = $$(date +'%Y%m%d-%H%M%S')

VERILATOR_BIN=$(VERILATOR_ROOT)/bin/verilator
BUILD_DIR=$(PWD)/$(DAY)_build

SIM_FLAGS=-Wno-WIDTH --prefix Vtop -o Vtop --exe

TOOLCMD = $(VERILATOR_BIN) $(SIM_FLAGS) --Mdir $(BUILD_DIR) --cc

compile: clean
	@mkdir -p $(BUILD_DIR)
	$(TOOLCMD) ../main.cpp $(DAY).sv $(DAY)_tb.sv $(DEPS)

sim: clean
	@mkdir -p $(BUILD_DIR)
	$(TOOLCMD) ../main.cpp $(DAY).sv $(DAY)_tb.sv $(DEPS)
	$(MAKE) -C $(BUILD_DIR)/ -f Vtop.mk
	@$(BUILD_DIR)/Vtop

build: clean
	touch synth.ys
	echo "plugin -i systemverilog" > synth.ys
	echo "read_systemverilog -DSYNTH $(DAY).sv " >> synth.ys
	echo "hierarchy -top $(DAY)" >> synth.ys
	echo "proc; opt; techmap; opt" >> synth.ys
	echo "write_verilog synth.v" >> synth.ys
	echo "show -prefix $(DAY) -colors $(TIME)" >> synth.ys

synth: build
	yosys synth.ys

clean:
	rm -rf sim.vvp synth.ys synth.v $(DAY).dot $(DAY).dot.pid $(DAY).vcd slpp_all $(BUILD_DIR)

