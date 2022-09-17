interface apb_slave_if (
  input		logic		clk,
  input		logic		reset
);
  
  logic 		psel;
  logic 		penable;
  logic [31:0]	paddr;
  logic			pwrite;
  logic [31:0]	pwdata;
  logic			pready;
  logic [31:0]	prdata;
  
  logic 		dmem_psel;
  logic 		dmem_penable;
  logic [31:0]	dmem_paddr;
  logic			dmem_pwrite;
  logic [31:0]	dmem_pwdata;
  logic			dmem_pready;
  logic [31:0]	dmem_prdata;
  
  
  clocking cb @(posedge clk);
    input 		psel;
    input		penable;
    input		paddr;
    input		pwrite;
    input		pwdata;
    inout		pready;
    inout		prdata;
    input 		dmem_psel;
    input		dmem_penable;
    input		dmem_paddr;
    input		dmem_pwrite;
    input		dmem_pwdata;
    inout		dmem_pready;
    inout		dmem_prdata;
  endclocking
endinterface