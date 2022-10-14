`include "uvm_macros.svh"

import uvm_pkg::*;

class apb_slave_monitor extends uvm_monitor;
  
  `uvm_component_utils(apb_slave_monitor);
  
  virtual apb_slave_if vif;
  uvm_analysis_port#(apb_slave_item) mon_analysis_port;
  
  function new (string name="apb_slave_monitor", uvm_component parent);
    super.new (name, parent);
  endfunction
  
  // Get the virtual interface handle in the build phase
  virtual function void build_phase (uvm_phase phase);
    super.build_phase (phase);
    if (!uvm_config_db#(virtual apb_slave_if)::get(this, "", "apb_slave_vif", vif)) begin
      `uvm_fatal("MONITOR", "Could not get a handle to the virtual interface");
    end
  endfunction
  
  // Monitor the interface in the run_phase
  virtual task run_phase (uvm_phase phase);
    super.run_phase (phase);
    forever begin
      @(posedge vif.clk);
      if (vif.psel & vif.penable & vif.pready) begin
        apb_slave_item item = new;
        item.prdata = vif.prdata;
        item.pwrite = vif.pwrite;
        item.pwdata = vif.pwdata;
        `uvm_info(get_type_name(), item.tx2string(), UVM_LOW)
        // Broadcast to all the subscriber class
        mon_analysis_port.write(item);
      end
    end
  endtask
  
endclass