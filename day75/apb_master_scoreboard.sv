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
    // Write into memory on a write
    if (item.psel & item.penable & item.pwrite & item.pready) begin
      mem[item.paddr] = item.pwdata;
    end
    if (item.psel & item.penable & ~item.pwrite & item.pready) begin
      // Read from the memory on a read
      mem_data = mem[item.paddr];
      if (mem_data !== item.prdata) begin
        `uvm_fatal("SCOREBOARD", $sformatf("APB Slave read data doesn't match. Expected: 0x%8x Got: 0x%8x", mem_data, item.prdata))
      end
    end
  endfunction
  
endclass