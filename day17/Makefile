DAY  = day17
TIME = $$(date +'%Y%m%d-%H%M%S')
DEPS = ../day3/day3.sv ../day7/day7.sv

TOOLCMD = iverilog -o sim.vvp -Wall -Winfloop -Wno-timescale -gno-shared-loop-index -g2012

compile: clean
	$(TOOLCMD) -s $(DAY) $(DEPS) $(DAY).sv

sim: clean
	$(TOOLCMD) -s $(DAY)_tb $(DAY).sv $(DEPS) $(DAY)_tb.sv
	/usr/local/bin/vvp ./sim.vvp
	gtkwave $(DAY).vcd -r ../gtkwaverc ./day14.gtkw&

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
	rm -rf sim.vvp synth.ys synth.v $(DAY).dot $(DAY).dot.pid $(DAY).vcd slpp_all

