// Driver - Sequence using get_next_item

`include "uvm_macros.svh"

import uvm_pkg::*;

class day58_data extends uvm_sequence_item;
  `uvm_object_utils (day58_data);
  rand int data;
  
  function new (string name="day58_data");
    super.new(name);
  endfunction
endclass

class day58_drv extends uvm_driver #(day58_data);
  
  `uvm_component_utils (day58_drv);

  function new (string name, uvm_component parent);
    super.new (name, parent);
  endfunction
  
  virtual task run_phase (uvm_phase phase);
    
    super.run_phase (phase);
    while (1) begin
      `uvm_info ("DRIVER", "Getting the next item from sequencer", UVM_LOW);
      seq_item_port.get_next_item(req);
    
      `uvm_info ("DRIVER", $sformatf("Got the following data: 0x%8x", req.data), UVM_LOW);
      // Wait for some time
      #5;
      // Done
      seq_item_port.item_done();
      `uvm_info("DRIVER", "Called item done", UVM_LOW);
    end
    
  endtask
  
endclass

// Sequence
class day58_seq extends uvm_sequence #(day58_data);
  
  `uvm_object_utils (day58_seq)
  
  function new (string name="day58_seq");
    super.new (name);
  endfunction
  
  virtual task body ();
    
    for (int i=0; i<50; i++) begin
      day58_data rand_data = day58_data::type_id::create("rand_data");
      void'(rand_data.randomize());
      `uvm_info ("SEQ", $sformatf("Starting to send item: 0x%8x", rand_data.data), UVM_LOW)
    
      start_item(rand_data);
      finish_item(rand_data);
    
      `uvm_info("SEQ", "After finish_item", UVM_LOW)

    end
  endtask
  
endclass

// Connect all of them together
class day58_test extends uvm_test;
  
  `uvm_component_utils (day58_test);
  
  day58_drv 			d_drv;
  day58_seq 			d_seq;
  uvm_sequencer #(day58_data) 	d_seqr;
  
  function new (string name, uvm_component component);
    super.new (name, component);
  endfunction
  
  // Build both sequencer and driver in the build phase
  virtual function void build_phase (uvm_phase phase);
    super.build_phase (phase);
    d_drv 	= day58_drv::type_id::create ("day58_drv", this);
    d_seqr	= uvm_sequencer#(day58_data)::type_id::create("day58_seqr", this);
  endfunction
  
  // Connect sequencer and driver
  virtual function void connect_phase (uvm_phase phase);
    
    super.connect_phase(phase);
    d_drv.seq_item_port.connect (d_seqr.seq_item_export);
    
  endfunction
  
  // Start the sequence in the run_phase
  virtual task run_phase (uvm_phase phase);
    
    d_seq = day58_seq::type_id::create("d_seq");
    phase.raise_objection(this);
    d_seq.start(d_seqr);
    phase.drop_objection(this);
  endtask
  
endclass

module day58_tb ();
  
  initial begin
    run_test ("day58_test");
  end
  
endmodule
