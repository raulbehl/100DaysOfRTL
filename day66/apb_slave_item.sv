`include "uvm_macros.svh"

import uvm_pkg::*;

class apb_slave_item extends uvm_sequence_item;
  
  bit				psel;
  bit				penable;
  bit				pwrite;
  bit [9:0]			paddr;
  bit [31:0]		pwdata;
  rand bit			pready;
  rand bit[31:0]	prdata;
  
  `uvm_object_utils (apb_slave_item);
  
  function new (string name = "apb_slave_item");
    super.new(name);
  endfunction
  
  // Helper function to get the transaction as a string
  virtual function string tx2string ();
    string tx;
    tx = $sformatf("pready=%b prdata=0x%8x", pready, prdata);
    return tx;
  endfunction
  
endclass
