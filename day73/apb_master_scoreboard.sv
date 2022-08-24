`include "uvm_macros.svh"

import uvm_pkg::*;

class apb_master_scoreboard extends uvm_scoreboard;
  
  `uvm_component_utils(apb_master_scoreboard);
  
  // Associative array to store write data
  bit[31:0] mem [bit[9:0]];
  uvm_analysis_imp #(apb_master_item, apb_master_scoreboard) m_analysis_imp;
  
  function new (string name="apb_master_scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    m_analysis_imp = new("apb_master_imp", this);
  endfunction
  
  // Implement the write function
  virtual function write (apb_master_item item);
    logic [31:0] mem_data;
    `uvm_info("SCOREBOARD", "Got a new transaction", UVM_LOW)
    // TODO
  endfunction
  
endclass