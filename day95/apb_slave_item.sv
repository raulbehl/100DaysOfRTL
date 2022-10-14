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
  
  bit				dmem_psel;
  bit				dmem_penable;
  bit				dmem_pwrite;
  bit [31:0]		dmem_paddr;
  bit [31:0]		dmem_pwdata;
  rand bit			dmem_pready;
  bit[31:0]			dmem_prdata;
  
  instr_type_t      instr_type;
  bit				instr_sub_type;
  
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
    tx = $sformatf("[IMEM] psel=%b penable=%b paddr=0x%x pwrite=%b pwdata=0x%x, pready=%b prdata=0x%8x",
                   psel, penable, paddr, pwrite, pwdata, pready, prdata);
    return tx;
  endfunction
  
  virtual function string mem_tx2string ();
    string tx;
    tx = $sformatf("[DMEM] psel=%b penable=%b paddr=0x%x pwrite=%b pwdata=0x%x, pready=%b prdata=0x%8x",
                   dmem_psel, dmem_penable, dmem_paddr, dmem_pwrite, dmem_pwdata, dmem_pready, dmem_prdata);
    return tx;
  endfunction
  
  virtual function string riscv_tx2string ();
    string tx;
    tx = $sformatf("opcode=%x rd=%x rs1=%x rs2=%x funct3=%x, funct7=%x, imm20=%x, imm12=%x",
                   opcode, rd, rs1, rs2, funct3, funct7, imm20, imm12);
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
        // Force instruction sub type to be zero if we are not processing
        // ADD or SRL instructions
        instr_sub_type = instr_sub_type & ((funct3 == ADD) | (funct3 == SRL));  
        case (instr_sub_type)
          0: funct7 = 7'h0;
          1: funct7 = 7'h20;
        endcase
        instruction = {funct7, rs2, rs1, funct3, rd, opcode};
      end
      I_TYPE: begin
        case (instr_sub_type)
          0 : begin
            case (funct3)
              ADDI,
          	  SLTI,
              SLTIU,
              XORI,
              ORI,
              ANDI:  instruction = {imm12, rs1, funct3, rd, opcode};
              SLLI,
              SRLI:  instruction = {7'h0, imm12[4:0], rs1, funct3, rd, opcode};
            endcase
          end
          1: begin
            instruction = {imm12, rs1, funct3, rd, 7'b0000011};
          end
        endcase
      end
      S_TYPE: instruction = {imm12[11:5], rs2, rs1, funct3, imm12[4:0], opcode};
      B_TYPE: instruction = {imm12[11], imm12[9:4], rs2, rs1, funct3, imm12[3:0], imm12[10], opcode};
      U_TYPE: begin
        case (instr_sub_type)
          0: instruction = {imm20, rd, 7'b0110111}; // LUI
          1: instruction = {imm20, rd, 7'b0010111}; // AUIPC
        endcase
      end
      J_TYPE: instruction = {imm20[19], imm20[9:0], imm20[10], imm20[18:11], rd, opcode};
    endcase
    prdata = instruction;
  endfunction
  
endclass