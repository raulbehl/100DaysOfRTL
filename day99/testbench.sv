// UVM Testbench for APB Master RTL
// Declare package to include all the files
`include "riscv_tb_pkg.sv"
package apb_slave_pkg;
	`include "riscv_model.sv"
	`include "riscv_tb_mem.sv"
	`include "apb_slave_item.sv"
	`include "apb_slave_basic_seq.sv"
	`include "apb_slave_driver.sv"
	`include "apb_slave_monitor.sv"
	`include "apb_slave_agent.sv"
	`include "apb_slave_scoreboard.sv"
	`include "apb_slave_env.sv"
	`include "apb_slave_test.sv"

endpackage

`include "uvm_macros.svh"

import uvm_pkg::*;
import apb_slave_pkg::*;
import riscv_tb_pkg::*;
`include "apb_intf.sv"
`include "riscv_reg_intf.sv"

module top ();
  
  logic		clk;
  logic		reset;
  
  // Instantiate RTL
  riscv_top RISCV (
    .clk					(clk),
    .reset					(reset),
    
    .imem_psel_o			(apb_slave_intf.psel),
    .imem_penable_o			(apb_slave_intf.penable),
    .imem_paddr_o			(apb_slave_intf.paddr),
    .imem_pwrite_o			(apb_slave_intf.pwrite),
    .imem_pwdata_o			(apb_slave_intf.pwdata),
    .imem_pready_i			(apb_slave_intf.pready),
    .imem_prdata_i			(apb_slave_intf.prdata),
    
    .dmem_psel_o			(apb_slave_intf.dmem_psel),
    .dmem_penable_o			(apb_slave_intf.dmem_penable),
    .dmem_paddr_o			(apb_slave_intf.dmem_paddr),
    .dmem_pwrite_o			(apb_slave_intf.dmem_pwrite),
    .dmem_pwdata_o			(apb_slave_intf.dmem_pwdata),
    .dmem_pready_i			(apb_slave_intf.dmem_pready),
    .dmem_prdata_i			(apb_slave_intf.dmem_prdata)
  );
  
  // Physical interface
  apb_slave_if apb_slave_intf (clk, reset);
  
  // Register interface for the checker
  riscv_reg_intf reg_intf();
  
  // TB Memory for data reads/writes
  riscv_tb_mem dmem;
  
  // RISCV Model
  riscv_model model;
  
  // Initialise registers
  initial begin
    for (int i=0; i<32; i++) begin
      RISCV.REGFILE.reg_file[i] = 32'(i);
      reg_intf.regfile[i] = RISCV.REGFILE.reg_file[i];
    end
  end
  
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
    dmem = new();
    model = new();
    // Set the TB memory handle
    uvm_config_db#(riscv_tb_mem)::set(null, "*", "riscv_tb_mem", dmem);
    uvm_config_db#(riscv_model)::set(null, "*", "riscv_model", model);
    uvm_config_db#(virtual riscv_reg_intf)::set(null, "*", "reg_intf", reg_intf);
    // Set the interface handle
    uvm_config_db#(virtual apb_slave_if)::set(null, "*", "apb_slave_vif", apb_slave_intf);
    `uvm_info("TOP", "apb_slave_vif set in the configdb", UVM_LOW)
    run_test ("apb_slave_test");
    #200;
    $finish();
  end
  
  initial begin
    $dumpfile ("apb_slave_tb.vcd");
    $dumpvars (0, top);
  end
  
endmodule