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
    logic [9:0] mem_data;
    // Write data to memory on a write
    if (item.psel & item.penable & item.pwrite & item.pready) begin
      mem[item.paddr] = item.pwdata;
    end
    // Read and check data from mem on a read
    if (item.psel & item.penable & ~item.pwrite & item.pready) begin
      mem_data = mem[item.paddr];
      if (item.prdata !== mem_data) begin
        `uvm_fatal(get_type_name(), $sformatf("Read data doesn't match the expected data. Data Read: 0x%8x, Expected: 0x%8x", item.prdata, mem_data))
      end
    end
  endfunction
  
endclass