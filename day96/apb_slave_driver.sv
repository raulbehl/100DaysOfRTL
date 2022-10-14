`include "uvm_macros.svh"

import uvm_pkg::*;

class apb_slave_driver extends uvm_driver #(apb_slave_item);
  
  `uvm_component_utils(apb_slave_driver);
  
  virtual apb_slave_if vif;
  
  function new (string name = "apb_slave_driver", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  // Get the virtual interface pointer in the build phase from configdb
  virtual function void build_phase (uvm_phase phase);
    super.build_phase (phase);
    if (!uvm_config_db#(virtual apb_slave_if)::get(this, "", "apb_slave_vif", vif)) begin
      `uvm_fatal("DRIVER", "Could not get the handle to the virtual interface");
    end
  endfunction
        
  // Drive the transaction in the run phase
  virtual task run_phase (uvm_phase phase);
    super.run_phase(phase);
    // Always try to get a new transaction from the sequencer
    forever begin
      apb_slave_item i_item;
      `uvm_info("DRIVER", "Waiting to get the item from the sequencer", UVM_LOW);
      seq_item_port.get_next_item(i_item);
      // Drive the sequence item on the RTL ports
      // Only need to drive the pready and prdata signals
      vif.cb.pready <= i_item.pready;
      vif.cb.prdata <= i_item.prdata;
      vif.cb.dmem_pready <= i_item.dmem_pready;
      vif.cb.dmem_prdata <= i_item.dmem_prdata;
      @(vif.cb);
      seq_item_port.item_done();
    end
  endtask
        
endclass