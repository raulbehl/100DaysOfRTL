// UVM Testbench for APB Master RTL
// Declare package to include all the files
package apb_master_pkg;

	`include "apb_master_item.sv"
	`include "apb_master_basic_seq.sv"
	`include "apb_master_raw_seq.sv"
	`include "apb_master_driver.sv"
	`include "apb_master_monitor.sv"
	`include "apb_master_agent.sv"
	`include "apb_master_scoreboard.sv"
	`include "apb_master_env.sv"
	`include "apb_master_test.sv"

endpackage

`include "uvm_macros.svh"

import uvm_pkg::*;
import apb_master_pkg::*;
`include "apb_intf.sv"

module top ();
  
  logic		clk;
  logic		reset;
  
  // Instantiate RTL
  day18 APB_SLAVE (
    .clk					(clk),
    .reset					(reset),
    .psel_i					(apb_master_intf.psel),
    .penable_i				(apb_master_intf.penable),
    .paddr_i				(apb_master_intf.paddr),
    .pwrite_i				(apb_master_intf.pwrite),
    .pwdata_i				(apb_master_intf.pwdata),
    .pready_o				(apb_master_intf.pready),
    .prdata_o				(apb_master_intf.prdata)
  );
  
  // Physical interface
  apb_master_if apb_master_intf (clk, reset);
  
  // Generate clock
  always begin
    clk = 1'b0;
    #5;
    clk = 1'b1;
    #5;
  end
  
  // Generate reset sequence and start the test
  initial begin
    reset = 1'b1;
    @(posedge clk);
    reset = 1'b0;
  end
  
  initial begin
    // Set the interface handle
    uvm_config_db#(virtual apb_master_if)::set(null, "*", "apb_master_vif", apb_master_intf);
    `uvm_info("TOP", "apb_master_vif set in the configdb", UVM_LOW)
    run_test ("apb_master_test");
    #200;
    $finish();
  end
  
  initial begin
    $dumpfile ("apb_master_tb.vcd");
    $dumpvars (0, top);
  end
  
endmodule