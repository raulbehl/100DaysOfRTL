interface apb_master_if (
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
    inout 		psel;
    inout		penable;
    inout		paddr;
    inout		pwrite;
    inout		pwdata;
    input		pready;
    input		prdata;
  endclocking
endinterface