`include "uvm_macros.svh"

import uvm_pkg::*;
import riscv_tb_pkg::*;

class apb_slave_item extends uvm_sequence_item;
  
  bit				psel;
  bit				penable;
  bit				pwrite;
  bit [31:0]		paddr;
  bit [31:0]		pwdata;
  rand bit			pready;
  bit[31:0]			prdata;
  
  instr_type_t      instr_type;
  
  bit [6:0]			opcode;
  rand bit [4:0]	rd;
  rand bit [4:0]	rs1;
  rand bit [4:0]	rs2;
  rand bit [2:0]	funct3;
  bit [6:0]			funct7;
  rand bit [19:0]	imm20;
  rand bit [11:0]	imm12;
  
  `uvm_object_utils (apb_slave_item);
  
  function new (string name = "apb_slave_item");
    super.new(name);
  endfunction
  
  // Helper function to get the transaction as a string
  virtual function string tx2string ();
    string tx;
    tx = $sformatf("psel=%b penable=%b paddr=0x%x pwrite=%b pwdata=0x%x, pready=%b prdata=0x%8x",
                   psel, penable, paddr, pwrite, pwdata, pready, prdata);
    return tx;
  endfunction
  
  // Construct the prdata based on the instruction type
  // Do this after randomisation
  function void post_randomize ();
    bit [31:0] instruction;
    // Default to R-type
    opcode = 7'h33;
    case (instr_type)
      R_TYPE: opcode = 7'h33;
      I_TYPE: opcode = 7'h13;
      S_TYPE: opcode = 7'h23;
      B_TYPE: opcode = 7'h63;
      J_TYPE: opcode = 7'h6F;
    endcase
    
    case (instr_type)
      R_TYPE: begin
        /*if ((funct3 == SUB) | (funct3 == SRA)) begin
          funct7 = 7'h20;
          funct3 = 
        end else begin
          funct7 = 7'h0;
        end*/
        funct7 = 7'h0;
        instruction = {funct7, rs2, rs1, funct3, rd, opcode};
      end
      I_TYPE: instruction = '0;
      S_TYPE: instruction = '0;
      B_TYPE: instruction = '0;
      J_TYPE: instruction = '0;
    endcase
    prdata = instruction;
  endfunction
  
endclass