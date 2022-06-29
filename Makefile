DAY = day$(day)
TIME = $$(date +'%Y%m%d-%H%M%S')
BASEDIR = $(shell pwd)

TOOLCMD = iverilog -o sim.vvp -Wall -Winfloop -Wno-timescale -gno-shared-loop-index -g2012

compile: clean
	$(TOOLCMD) -s $(DAY) $(DAY).sv

sim: clean
	cd "$(BASEDIR)/$(DAY)"; \
	$(TOOLCMD) -s $(DAY)_tb $(DAY).sv $(DAY)_tb.sv; \
	/usr/local/bin/vvp ./sim.vvp; \
	gtkwave $(DAY).vcd -r ../gtkwaverc &

build: clean
	touch synth.ys
	echo "read -sv $(DAY).sv" > synth.ys
	echo "hierarchy -top $(DAY)" >> synth.ys
	echo "proc; opt; techmap; opt" >> synth.ys
	echo "write_verilog synth.v" >> synth.ys
	echo "show -prefix $(DAY) -colors $(TIME)" >> synth.ys

synth: build
	cd "$(BASEDIR)/$(DAY)"; \
	yosys synth.ys

clean:
	cd "$(BASEDIR)/$(DAY)"; \
	rm -rf sim.vvp synth.ys synth.v $(DAY).dot $(DAY).dot.pid $(DAY).vcd

