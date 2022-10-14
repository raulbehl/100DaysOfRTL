`include "uvm_macros.svh"

import uvm_pkg::*;

class apb_slave_scoreboard extends uvm_scoreboard;
  
  `uvm_component_utils(apb_slave_scoreboard);
  
  // Associative array to store write data
  bit[31:0] mem [bit[9:0]];
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
    // Write data should be previous read data + 1
    if (item.psel & item.penable & item.pwrite & item.pready) begin
      mem_data = mem[item.paddr] + 1;
      if (item.pwdata !== mem_data) begin
        `uvm_fatal(get_type_name(), $sformatf("Read data doesn't match the expected data. Data Read: 0x%8x, Expected: 0x%8x", item.pwdata, mem_data))
      end
    end
    // On a read, store the read data to be compared on next write
    if (item.psel & item.penable & ~item.pwrite & item.pready) begin
      `uvm_info(get_type_name(), $sformatf("Storing read data (%x) into memory", item.prdata), UVM_LOW)
      mem[item.paddr] = item.prdata;
    end
  endfunction
  
endclass