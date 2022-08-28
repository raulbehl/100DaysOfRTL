`include "uvm_macros.svh"

import uvm_pkg::*;

class apb_master_item extends uvm_sequence_item;
  
  rand bit				psel;
  rand bit				penable;
  rand bit				pwrite;
  rand bit [9:0]		paddr;
  rand bit [31:0]		pwdata;
  logic					pready;
  logic[31:0]			prdata;
  
  `uvm_object_utils (apb_master_item);
  
  function new (string name = "apb_master_item");
    super.new(name);
  endfunction
  
  // Helper function to get the transaction as a string
  virtual function string tx2string ();
    string tx;
    tx = $sformatf("psel=%b penable=%b paddr=0x%x pwrite=%b pwdata=0x%x, pready=%b prdata=0x%8x",
                   psel, penable, paddr, pwrite, pwdata, pready, prdata);
    return tx;
  endfunction
  
endclass