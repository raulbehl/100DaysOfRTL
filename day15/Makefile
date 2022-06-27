DAY  = day15
DEPS = ../day14/day14.sv
TIME = $$(date +'%Y%m%d-%H%M%S')

TOOLCMD = iverilog -o sim.vvp -Wall -Winfloop -Wno-timescale -gno-shared-loop-index -g2012

compile: clean
	$(TOOLCMD) -s $(DAY) $(DAY).sv $(DEPS)

sim: clean
	$(TOOLCMD) -s $(DAY)_tb $(DAY).sv $(DAY)_tb.sv $(DEPS)
	/usr/local/bin/vvp ./sim.vvp
	gtkwave $(DAY).vcd -r ../gtkwaverc &

build: clean
	touch synth.ys
	echo "plugin -i systemverilog" > synth.ys
	echo "read_systemverilog $(DAY).sv " >> synth.ys
	echo "hierarchy -top $(DAY)" >> synth.ys
	echo "proc; opt; techmap; opt" >> synth.ys
	echo "write_verilog synth.v" >> synth.ys
	echo "show -prefix $(DAY) -colors $(TIME)" >> synth.ys

synth: build
	yosys synth.ys

clean:
	rm -rf sim.vvp synth.ys synth.v $(DAY).dot $(DAY).dot.pid $(DAY).vcd slpp_all

