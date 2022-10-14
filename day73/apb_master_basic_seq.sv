`include "uvm_macros.svh"

import uvm_pkg::*;

class apb_master_basic_seq extends uvm_sequence;
  
  `uvm_object_utils(apb_master_basic_seq);
  
  // Number of transactions to be sent
  rand int num_txn;
  
  function new (string name="apb_master_basic_seq");
    super.new(name);
  endfunction
  
  // Allow anywhere betweeen 20-100 APB transactions
  constraint apb_num_txn {num_txn inside {[100:500]}; }
  
  // Generate the item in the body
  virtual task body();
    string tx;
    for (int i=0; i<num_txn; i++) begin
      apb_master_item seq_item = apb_master_item::type_id::create("seq_item");
	  `uvm_info("SEQUENCE", "Starting a new APB master item", UVM_LOW);
      start_item(seq_item);
      void'(seq_item.randomize());
      tx = seq_item.tx2string();
      `uvm_info("SEQUENCE", $sformatf("Generated a new APB master item:\n%s", tx), UVM_LOW);
      finish_item(seq_item);
    end
    `uvm_info("SEQUENCE", "Finished sending APB master items", UVM_LOW);
  endtask
  
endclass