`include "uvm_macros.svh"

import uvm_pkg::*;

class apb_master_raw_seq extends uvm_sequence;
  
  `uvm_object_utils(apb_master_raw_seq);
  
  // Number of transactions to be sent
  rand int num_txn;
  // Store the write addr to be used for the next read
  bit [9:0] wr_addr[$];
  
  function new (string name="apb_master_raw_seq");
    super.new(name);
  endfunction
  
  // Allow anywhere betweeen 20-100 APB transactions
  constraint apb_num_txn {num_txn inside {[20:100]}; }
  
  // Generate the item in the body
  virtual task body();
    string tx;
    for (int i=0; i<num_txn; i++) begin
      apb_master_item seq_item = apb_master_item::type_id::create("seq_item");
      
      // -------------------------------------------------------------------
      // The first transaction should be a write transaction
      // -------------------------------------------------------------------
      `uvm_info("SEQUENCE", "Starting a new APB master write seq item", UVM_LOW);
      start_item(seq_item);
      void'(seq_item.randomize() with {seq_item.psel   == 1 &&
        							   seq_item.pwrite == 1;});
      // Store the paddr in the queue
      wr_addr.push_back(seq_item.paddr);
      tx = seq_item.tx2string();
      `uvm_info("SEQUENCE", $sformatf("Generated a new APB master item:\n%s", tx), UVM_LOW);
      finish_item(seq_item);
      
      // -------------------------------------------------------------------
	  // The first transaction should be a write transaction
      // -------------------------------------------------------------------
      `uvm_info("SEQUENCE", "Starting a new APB master read seq item", UVM_LOW);
      start_item(seq_item);
      wr_addr.shuffle();
      void'(seq_item.randomize() with {seq_item.psel   == 1 &&
        							   seq_item.pwrite == 0 &&
                                       seq_item.paddr  == wr_addr[0];});
      tx = seq_item.tx2string();
      `uvm_info("SEQUENCE", $sformatf("Generated a new APB master item:\n%s", tx), UVM_LOW);
      finish_item(seq_item);
    end
    `uvm_info("SEQUENCE", "Finished sending APB master items", UVM_LOW);
  endtask
  
endclass