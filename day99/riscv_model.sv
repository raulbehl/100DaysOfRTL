`include "uvm_macros.svh"

import uvm_pkg::*;
import riscv_tb_pkg::*;

class riscv_model;
  
  bit[31:0] regfile [31:0];
  
  instr_type_t      instr_type;
  bit				instr_sub_type;
  
  bit [6:0]			opcode;
  bit [4:0]			rd;
  bit [4:0]			rs1;
  bit [4:0]			rs2;
  bit [2:0]			funct3;
  bit [6:0]			funct7;
  bit [19:0]		imm20;
  bit [11:0]		imm12;

  virtual riscv_reg_intf reg_vif;
  
  function void get_intf ();
    if (!uvm_config_db#(virtual riscv_reg_intf)::get(null, "", "reg_intf", reg_vif)) begin
      `uvm_fatal("MODEL", "Could not get the handle to the virtual register interface");
    end
    for (int i=0; i<32; i++) begin
      regfile[i] = 32'(i);
    end
  endfunction
  
  function void set (instr_type_t instr_type, bit instr_sub_type, bit [6:0] opcode, bit [4:0] rd, bit [4:0] rs1,
                     bit [4:0] rs2, bit [2:0] funct3, bit [6:0] funct7, bit [19:0] imm20, bit [11:0] imm12);
    
    this.instr_type = instr_type;
    this.instr_sub_type = instr_sub_type;
    this.opcode = opcode;
    this.rd = rd;
    this.rs1 = rs1;
    this.rs2 = rs2;
    this.funct3 = funct3;
    this.funct7 = funct7;
    this.imm20 = imm20;
    this.imm12 = imm12;
    
  endfunction
  
  function void exec ();
    // Execute the instruction
    case (instr_type)  
      R_TYPE: begin  
        case ({instr_sub_type, funct3})
          {1'b0, ADD}: regfile[this.rd] = regfile[this.rs1] + regfile[this.rs2];
          {1'b0, SLL}: regfile[this.rd] = regfile[this.rs1] << regfile[this.rs2][4:0];
          {1'b0, SLT}: regfile[this.rd] = regfile[this.rs1] < regfile[this.rs2];
          {1'b0, SLTU}:regfile[this.rd] = unsigned'(regfile[this.rs1]) < unsigned'(regfile[this.rs2]);
          {1'b0, XOR}: regfile[this.rd] = regfile[this.rs1] ^ regfile[this.rs2];
          {1'b0, SRL}: regfile[this.rd] = regfile[this.rs1] >> regfile[this.rs2][4:0];
          {1'b0,OR}:   regfile[this.rd] = regfile[this.rs1] | regfile[this.rs2];
          {1'b0, AND}: regfile[this.rd] = regfile[this.rs1] & regfile[this.rs2];
          //1: funct7 = 7'h20;
        endcase
      end
      /*I_TYPE: begin
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
      J_TYPE: instruction = {imm20[19], imm20[9:0], imm20[10], imm20[18:11], rd, opcode};*/
    endcase
  endfunction
  
  function void compare ();
    // Compare the contents of regfile with RTL
    int i = 0;
    
    for (i=0; i<32; i++) begin
      if (regfile[i] !== reg_vif.regfile[i]) begin
        $fatal(1, "Register file contents do not match for register X%2d. Expected: 0x%8x Got: 0x%8x",
               i, regfile[i], reg_vif.regfile[i]);
      end
    end
  endfunction
  
endclass