`include "uvm_macros.svh"

import uvm_pkg::*;

class day61_item extends uvm_sequence_item;
  
  rand bit			pready;
  rand bit[31:0]	prdata;
  
  `uvm_object_utils (day61_item);
  
  function new (string name = "day61_item");
    super.new(name);
  endfunction
  
  // Helper function to get the transaction as a string
  virtual function string tx2string ();
    string tx;
    tx = $sformatf("pready=%b prdata=0x%8x", pready, prdata);
    return tx;
  endfunction
  
endclass
