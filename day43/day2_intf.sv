// Simple interface for a mux

interface day2_if (
	input	wire		clk,
  	input	wire		reset
);

	logic      d;

	logic      q_norst;
	logic      q_syncrst;
	logic      q_asyncrst;
  
  // Clocking block
  clocking cb @(posedge clk);
    output #1step d;
    input  #0 q_norst;
    input  #0 q_syncrst;
    input  #0 q_asyncrst;
  endclocking

endinterface
