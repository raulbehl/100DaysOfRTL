`include "uvm_macros.svh"

import uvm_pkg::*;

class apb_slave_test extends uvm_test;
  
  `uvm_component_utils(apb_slave_test)
  apb_slave_env e0;
  virtual apb_slave_if vif;
  
  function new (string name="apb_slave_test", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    e0 = apb_slave_env::type_id::create("e0", this);
    // Get the virtual interface handle from config db
    if (!uvm_config_db#(virtual apb_slave_if)::get(this, "", "apb_slave_vif", vif)) begin
      `uvm_fatal("TEST", "Unable to get handle to the virtual interface")
    end
	// Set the interface in config db
    uvm_config_db#(virtual apb_slave_if)::set(this, "e0.a0.*", "apb_slave_vif", vif);
  endfunction
  
  // Start the sequence in the run_phase
   task run_phase(uvm_phase phase);
    apb_slave_basic_seq seq = apb_slave_basic_seq::type_id::create("seq");
    phase.raise_objection(this);
    seq.randomize();
    seq.start(e0.a0.s0);
    phase.drop_objection(this);
  endtask
  
endclass