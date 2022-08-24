`include "uvm_macros.svh"

import uvm_pkg::*;

class apb_master_driver extends uvm_driver #(apb_master_item);
  
  `uvm_component_utils(apb_master_driver);
  
  virtual apb_master_if vif;
  
  function new (string name = "apb_master_driver", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  // Get the virtual interface pointer in the build phase from configdb
  virtual function void build_phase (uvm_phase phase);
    super.build_phase (phase);
    if (!uvm_config_db#(virtual apb_master_if)::get(this, "", "apb_master_vif", vif)) begin
      `uvm_fatal("DRIVER", "Could not get the handle to the virtual interface");
    end
  endfunction
        
  // Drive the transaction in the run phase
  virtual task run_phase (uvm_phase phase);
    super.run_phase(phase);
    // Always try to get a new transaction from the sequencer
    forever begin
      apb_master_item d_item;
      `uvm_info("DRIVER", "Waiting to get the item from the sequencer", UVM_LOW);
      seq_item_port.get_next_item(d_item);
      // Drive the sequence item on the RTL ports
      // Only need to drive the pready and prdata signals
	  // TODO
      vif.psel <= 1'b0;
      vif.penable <= 1'b0;
      @(vif.cb);
      seq_item_port.item_done();
    end
  endtask
        
endclass