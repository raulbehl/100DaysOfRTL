// Simple interface for a mux

interface day10_if (
	input	wire		clk,
  	input	wire		reset
);

  logic      load;
  logic[3:0] load_val;

  logic[3:0] count;

  // Clocking block
  clocking cb @(posedge clk);
    output #1step load;
    output #1step load_val;
    input  #0 count;
  endclocking

endinterface
