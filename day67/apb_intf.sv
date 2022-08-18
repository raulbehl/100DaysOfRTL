interface apb_intf (
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
  
endinterface
