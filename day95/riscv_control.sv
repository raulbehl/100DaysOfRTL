`include "riscv_pkg.sv"

module riscv_control import riscv_pkg::*; (
  input		wire[2:0]	instr_funct3_i,
  input		wire[6:0]	instr_funct7_i,
  input		wire[6:0]	instr_op_i,
  input		wire		is_r_type_i,
  input		wire		is_i_type_i,
  input		wire		is_s_type_i,
  input		wire		is_b_type_i,
  input		wire		is_u_type_i,
  input		wire		is_j_type_i,
  output	logic[1:0]	pc_sel_o,
  output	logic		op1_sel_o,
  output	logic[1:0]	op2_sel_o,
  output	logic[1:0]	wb_sel_o,
  output	logic		pc4_sel_o,
  output	logic		mem_wr_o,
  output	logic		cpr_en_o,
  output	logic		rf_en_o,
  output	logic[3:0]	alu_op_o
);
  
  logic[14:0] controls;
  logic[3:0] instr_funct_ctl;
  logic[4:0] instr_op_ctl;
  
  assign {pc_sel_o, op1_sel_o, op2_sel_o, wb_sel_o,
          pc4_sel_o, mem_wr_o, cpr_en_o, rf_en_o, alu_op_o} = controls;
  
  assign instr_funct_ctl = {instr_funct7_i[5], instr_funct3_i};
  assign instr_op_ctl = {instr_op_i[4], {1'b0, instr_funct3_i}};
  
  always_comb begin
    case (1'b1)
      is_r_type_i : begin
        // Drive control signals for the R-type instruction
        case (instr_funct_ctl)
          ADD 	: controls = {2'b00, 1'b0, 2'b11, 2'b01, 1'b0, 1'b0, 1'b0, 1'b1, OP_ADD};
          AND 	: controls = {2'b00, 1'b0, 2'b11, 2'b01, 1'b0, 1'b0, 1'b0, 1'b1, OP_AND};
          OR  	: controls = {2'b00, 1'b0, 2'b11, 2'b01, 1'b0, 1'b0, 1'b0, 1'b1, OP_OR};
          SLL 	: controls = {2'b00, 1'b0, 2'b11, 2'b01, 1'b0, 1'b0, 1'b0, 1'b1, OP_SLL};
          SLT 	: controls = {2'b00, 1'b0, 2'b11, 2'b01, 1'b0, 1'b0, 1'b0, 1'b1, OP_SLT};
          SLTU	: controls = {2'b00, 1'b0, 2'b11, 2'b01, 1'b0, 1'b0, 1'b0, 1'b1, OP_SLT};
          SRA	: controls = {2'b00, 1'b0, 2'b11, 2'b01, 1'b0, 1'b0, 1'b0, 1'b1, OP_ASR};
          SRL	: controls = {2'b00, 1'b0, 2'b11, 2'b01, 1'b0, 1'b0, 1'b0, 1'b1, OP_LSR};
          SUB	: controls = {2'b00, 1'b0, 2'b11, 2'b01, 1'b0, 1'b0, 1'b0, 1'b1, OP_SUB};
          XOR	: controls = {2'b00, 1'b0, 2'b11, 2'b01, 1'b0, 1'b0, 1'b0, 1'b1, OP_XOR};
          default: controls = {2'b00, 1'b0, 2'b11, 2'b01, 1'b0, 1'b0, 1'b0, 1'b1, OP_ADD};
        endcase
      end
	  is_i_type_i : begin
        case (instr_op_ctl)
          LB  	: controls = {2'b00, 1'b0, 2'b01, 2'b00, 1'b0, 1'b0, 1'b0, 1'b1, OP_ADD};
	      LBU 	: controls = {2'b00, 1'b0, 2'b01, 2'b00, 1'b0, 1'b0, 1'b0, 1'b1, OP_ADD};
	      LH  	: controls = {2'b00, 1'b0, 2'b01, 2'b00, 1'b0, 1'b0, 1'b0, 1'b1, OP_ADD};
	      LHU 	: controls = {2'b00, 1'b0, 2'b01, 2'b00, 1'b0, 1'b0, 1'b0, 1'b1, OP_ADD};
	      LW  	: controls = {2'b00, 1'b0, 2'b01, 2'b00, 1'b0, 1'b0, 1'b0, 1'b1, OP_ADD};
          ADDI	: controls = {2'b00, 1'b0, 2'b01, 2'b01, 1'b1, 1'b0, 1'b0, 1'b1, OP_ADD};
          ANDI	: controls = {2'b00, 1'b0, 2'b01, 2'b01, 1'b0, 1'b0, 1'b0, 1'b1, OP_AND};
          ORI 	: controls = {2'b00, 1'b0, 2'b01, 2'b01, 1'b0, 1'b0, 1'b0, 1'b1, OP_OR};
          SLLI	: controls = {2'b00, 1'b0, 2'b01, 2'b01, 1'b0, 1'b0, 1'b0, 1'b1, OP_SLL};
          SRLI	: controls = {2'b00, 1'b0, 2'b01, 2'b01, 1'b0, 1'b0, 1'b0, 1'b1, OP_LSR};
          SLTI	: controls = {2'b00, 1'b0, 2'b01, 2'b01, 1'b0, 1'b0, 1'b0, 1'b1, OP_SLT};
          SLTIU	: controls = {2'b00, 1'b0, 2'b01, 2'b01, 1'b0, 1'b0, 1'b0, 1'b1, OP_SLT};
          //SRAI 	: controls = {2'b00, 1'b0, 2'b01, 2'b01, 1'b0, 1'b0, 1'b0, 1'b1, OP_ASR};
          XORI	: controls = {2'b00, 1'b0, 2'b01, 2'b01, 1'b0, 1'b0, 1'b0, 1'b1, OP_XOR};
          JALR	: controls = {2'b00, 1'b0, 2'b01, 2'b10, 1'b1, 1'b0, 1'b0, 1'b1, OP_ADD};
          default:  controls = {2'b00, 1'b0, 2'b01, 2'b00, 1'b0, 1'b0, 1'b0, 1'b1, OP_ADD};
        endcase
      end
      is_s_type_i : begin
        case (6'(instr_funct3_i))
          SB: controls = {2'b00, 1'b0, 2'b01, 2'b01, 1'b0, 1'b1, 1'b0, 1'b0, OP_ADD};
          SH: controls = {2'b00, 1'b0, 2'b01, 2'b01, 1'b0, 1'b1, 1'b0, 1'b0, OP_ADD};
          SW: controls = {2'b00, 1'b0, 2'b01, 2'b01, 1'b0, 1'b1, 1'b0, 1'b0, OP_ADD};
          default: controls = '0;
        endcase
      end
      is_b_type_i : begin
        case (6'(instr_funct3_i))
          BEQ	: controls = {2'b01, 1'b0, 2'b11, 2'b00, 1'b0, 1'b0, 1'b0, 1'b0, OP_SUB};
          BNE	: controls = {2'b01, 1'b0, 2'b11, 2'b00, 1'b0, 1'b0, 1'b0, 1'b0, OP_SUB};
          BLT	: controls = {2'b01, 1'b0, 2'b11, 2'b00, 1'b0, 1'b0, 1'b0, 1'b0, OP_SUB};
          BGE	: controls = {2'b01, 1'b0, 2'b11, 2'b00, 1'b0, 1'b0, 1'b0, 1'b0, OP_SUB};
          BLTU	: controls = {2'b01, 1'b0, 2'b11, 2'b00, 1'b0, 1'b0, 1'b0, 1'b0, OP_ULT};
          BGEU	: controls = {2'b01, 1'b0, 2'b11, 2'b00, 1'b0, 1'b0, 1'b0, 1'b0, OP_UGT};
          default: controls = '0;
        endcase
      end
      is_u_type_i : begin
        case (instr_op_i[5:0])
          AUIPC : controls = {2'b00, 1'b1, 2'b10, 2'b01, 1'b0, 1'b0, 1'b0, 1'b1, OP_ADD};
          LUI	: controls = {2'b00, 1'b1, 2'b00, 2'b01, 1'b0, 1'b0, 1'b0, 1'b1, OP_ADD};
          default: controls = '0;
        endcase
      end
      is_j_type_i : begin
        controls = {2'b01, 1'b1, 2'b10, 2'b01, 1'b0, 1'b0, 1'b0, 1'b1, OP_ADD};
      end
      default: controls = '0;
    endcase
  end
  
endmodule