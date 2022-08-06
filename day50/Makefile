DAY  = day14
TIME = $$(date +'%Y%m%d-%H%M%S')

TOOLCMD = iverilog -o sim.vvp -Wall -Winfloop -Wno-timescale -gno-shared-loop-index -g2012

compile: clean
	$(TOOLCMD) -s $(DAY) $(DAY).sv

sim: clean
	$(TOOLCMD) -s $(DAY)_tb $(DAY).sv $(DAY)_tb.sv
	/usr/local/bin/vvp ./sim.vvp
	gtkwave $(DAY).vcd -r ../gtkwaverc &

synth_build: clean
	touch synth.ys
	echo "read -sv $(DAY).sv" > synth.ys
	echo "hierarchy -top $(DAY)" >> synth.ys
	echo "proc; opt; techmap; opt" >> synth.ys
	echo "write_verilog synth.v" >> synth.ys
	echo "show -prefix $(DAY) -colors $(TIME)" >> synth.ys

synth: synth_build
	yosys synth.ys

formal_build: clean
	touch $(DAY).sby
	echo "[options]" > $(DAY).sby
	echo "mode bmc" >> $(DAY).sby
	echo "[engines]" >> $(DAY).sby
	echo "smtbmc" >> $(DAY).sby
	echo "[script]" >> $(DAY).sby
	echo "plugin -i systemverilog" >> $(DAY).sby
	echo "read_systemverilog -DFORMAL $(DAY).sv" >> $(DAY).sby
	echo "prep -top $(DAY)" >> $(DAY).sby
	echo "[files]" >> $(DAY).sby
	echo "$(DAY).sv" >> $(DAY).sby
	echo "../prim_assert.sv" >> $(DAY).sby
	echo "../prim_assert_yosys_macros.svh" >> $(DAY).sby
	echo "../prim_assert_sec_cm.svh" >> $(DAY).sby
	echo "../prim_flop_macros.sv" >> $(DAY).sby

formal: formal_build
	sby -f $(DAY).sby

clean:
	rm -rf sim.vvp synth.ys synth.v $(DAY).dot $(DAY).dot.pid $(DAY).vcd $(DAY).sby $(DAY)

