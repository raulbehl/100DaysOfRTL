`include "uvm_macros.svh"

import uvm_pkg::*;

class apb_master_coverage extends uvm_subscriber #(apb_master_item);
  
  `uvm_component_utils(apb_master_coverage);
  
  apb_master_item cov_item;
  
  // A simple covergroup
  covergroup apb_master_cg;
    coverpoint cov_item.paddr {
      bins addr[16] = {[0:511]};
    }
    coverpoint cov_item.pwdata {
      bins data_lo[1]  = {[0:255]};
      bins data_mid[1] = {[256:511]};
      bins data_hi[1]  = {[512:2**32-1]};
    }
  endgroup
  
  function new (string name="apb_master_coverage", uvm_component parent);
    super.new(name, parent);
    apb_master_cg = new();
  endfunction
  
  // Implement the write function
  virtual function void write (apb_master_item t);
    // Sample coverage whenever a new item is seen
    cov_item = t;
    apb_master_cg.sample();
  endfunction
  
  virtual function void check_phase (uvm_phase phase);
    super.check_phase(phase);
    `uvm_info(get_type_name(), $sformatf("Collected coverage is: %0.2f%%", apb_master_cg.get_inst_coverage()), UVM_LOW)
  endfunction
  
endclass