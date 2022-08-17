// A simple hello world using uvm_test

`include "uvm_macros.svh"

// Import uvm_pkg
import uvm_pkg::*;

class day56 extends uvm_test;

  // Register with factory
  `uvm_component_utils(day56)
  
  // Call super.new in the new function
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  // Display hello world in the run_phase
  virtual task run_phase (uvm_phase phase);
    `uvm_info("Day56", "Hello, World!", UVM_LOW);
  endtask
  
  // Print topology at the end of elaboration
  virtual function void end_of_elaboration_phase (uvm_phase phase);
    uvm_top.print_topology();
  endfunction
  
endclass

// Call the run_test in the TB
module day56_tb ();
  
  initial begin
    run_test ("day56");
  end
  
endmodule
