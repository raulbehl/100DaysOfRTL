`include "uvm_macros.svh"

import uvm_pkg::*;

class apb_slave_scoreboard extends uvm_scoreboard;
  
  `uvm_component_utils(apb_slave_scoreboard);
  // Associative array to store write data
  // FIXME: Should be able to read from mem while creating
  // the sequence item
  bit[31:0] dmem [bit[31:0]];
  
  // TODO: Model RV32I operations here
  bit [31:0] regfile;
  
  uvm_analysis_imp #(apb_slave_item, apb_slave_scoreboard) m_analysis_imp;
  
  function new (string name="apb_slave_scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    m_analysis_imp = new("apb_slave_imp", this);
  endfunction
  
  // Implement the write function
  virtual function write (apb_slave_item item);
    logic [31:0] mem_data;
    `uvm_info("SCOREBOARD", "Got a new transaction", UVM_LOW)
    // Write data into the memory on a write
    if (item.psel & item.penable & item.pwrite & item.pready) begin
      mem_data = item.pwdata;
      dmem[item.paddr] = mem_data;
    end
    // Read data from memory on a read
    if (item.psel & item.penable & ~item.pwrite & item.pready) begin
      mem_data = dmem[item.paddr];
    end
  endfunction
  
endclass