`include "uvm_macros.svh"

import uvm_pkg::*;

class apb_master_monitor extends uvm_monitor;
  
  `uvm_component_utils(apb_master_monitor);
  
  virtual apb_master_if vif;
  uvm_analysis_port#(apb_master_item) mon_analysis_port;
  
  function new (string name="apb_master_monitor", uvm_component parent);
    super.new (name, parent);
  endfunction
  
  // Get the virtual interface handle in the build phase
  virtual function void build_phase (uvm_phase phase);
    super.build_phase (phase);
    mon_analysis_port = new("mon_analysis_port", this);
    if (!uvm_config_db#(virtual apb_master_if)::get(this, "", "apb_master_vif", vif)) begin
      `uvm_fatal("MONITOR", "Could not get a handle to the virtual interface");
    end
  endfunction
  
  // Monitor the interface in the run_phase
  virtual task run_phase (uvm_phase phase);
    apb_master_item item = new;
    super.run_phase (phase);
    forever begin
      item.psel   	= vif.cb.psel;
      item.penable	= vif.cb.penable;
      item.paddr	= vif.cb.paddr;
      item.prdata 	= vif.cb.prdata;
      item.pwrite 	= vif.cb.pwrite;
      item.pwdata 	= vif.cb.pwdata;
      item.pready	= vif.cb.pready;
      `uvm_info(get_type_name(), item.tx2string(), UVM_LOW)
      // Broadcast to all the subscriber class
      mon_analysis_port.write(item);
      @(vif.cb);
    end
  endtask
  
endclass