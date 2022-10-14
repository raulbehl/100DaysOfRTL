// UVM Testbench for APB Master RTL
`include "uvm_macros.svh"

import uvm_pkg::*;
`include "apb_intf.sv"

module top ();
  
  logic		clk;
  logic		reset;
  
  // Instantiate RTL
  apb_master APB_MASTER (
    .clk					(clk),
    .reset					(reset),
    .psel_o					(apb_slave_intf.psel),
    .penable_o				(apb_slave_intf.penable),
    .paddr_o				(apb_slave_intf.paddr),
    .pwrite_o				(apb_slave_intf.pwrite),
    .pwdata_o				(apb_slave_intf.pwdata),
    .pready_i				(apb_slave_intf.pready),
    .prdata_i				(apb_slave_intf.prdata)
  );
  
  // Physical interface
  apb_slave_if apb_slave_intf (clk, reset);
  
  // Generate clock
  always begin
    clk = 1'b1;
    #5;
    clk = 1'b0;
    #5;
  end
  
  // Generate reset sequence and start the test
  initial begin
    reset = 1'b1;
    @(posedge clk);
    reset = 1'b0;
    run_test ("apb_slave_test");
    #200;
    $finish();
  end
  
endmodule

// Declare package to include all the files
package apb_slave_pkg;

	`include "apb_slave_item.sv"
	`include "apb_slave_basic_seq.sv"
	`include "apb_slave_driver.sv"
	`include "apb_slave_monitor.sv"
	`include "apb_slave_agent.sv"
	`include "apb_slave_scoreboard.sv"
	`include "apb_slave_env.sv"
	`include "apb_slave_test.sv"

endpackage