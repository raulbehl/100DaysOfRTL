interface apb_slave_if (
  input		logic		clk,
  input		logic		reset
);
  
  logic 		psel;
  logic 		penable;
  logic [9:0]	paddr;
  logic			pwrite;
  logic [31:0]	pwdata;
  logic			pready;
  logic [31:0]	prdata;
  
  
  clocking cb @(posedge clk);
    input 		psel;
    input		penable;
    input		paddr;
    input		pwrite;
    input		pwdata;
    inout		pready;
    inout		prdata;
  endclocking
endinterface