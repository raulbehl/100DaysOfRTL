`include "riscv_pkg.sv"
`include "riscv_fetch.sv"
`include "riscv_decode.sv"
`include "riscv_regfile.sv"
`include "riscv_execute.sv"
`include "riscv_dmem.sv"
`include "riscv_control.sv"

module riscv_top (
  input		  wire		  clk,
  input		  wire		  reset,
  
  output	  wire		  imem_psel_o,
  output      wire        imem_penable_o,
  output      wire[31:0]  imem_paddr_o,
  output      wire        imem_pwrite_o,
  output      wire[31:0]  imem_pwdata_o,
  input       wire        imem_pready_i,
  input       wire[31:0]  imem_prdata_i,
  
  output	  wire		  dmem_psel_o,
  output      wire        dmem_penable_o,
  output      wire[31:0]  dmem_paddr_o,
  output      wire        dmem_pwrite_o,
  output      wire[31:0]  dmem_pwdata_o,
  input       wire        dmem_pready_i,
  input       wire[31:0]  dmem_prdata_i
);
  
  wire 			instr_done;
  wire 			if_dec_valid;
  wire [31:0]	if_dec_instr;
  wire [31:0]	ex_if_pc;
  wire [4:0]	rs1;
  wire [4:0]	rs2;
  wire [4:0]	rd;
  wire [6:0]	op;
  wire [2:0]	funct3;
  wire [6:0]	funct7;
  logic			is_r_type;
  logic			is_i_type;
  logic			is_s_type;
  logic			is_b_type;
  logic			is_u_type;
  logic			is_j_type;
  logic[11:0] 	i_type_imm;
  logic[11:0] 	s_type_imm;
  logic[11:0] 	b_type_imm;
  logic[19:0] 	u_type_imm;
  logic[19:0] 	j_type_imm;
  logic[1:0]	pc_sel;
  logic			op1_sel;
  logic[1:0]	op2_sel;
  logic[1:0]	wb_sel;
  logic			pc4_sel;
  logic			mem_wr;
  logic			cpr_en;
  logic			rf_en;
  logic[3:0]	alu_op;
  wire			rf_wr_en;
  wire[4:0]		rf_wr_addr;
  wire[31:0]	rf_wr_data;
  wire[4:0]		rf_rd_p0;
  wire[4:0]		rf_rd_p1;
  wire[31:0]	rf_rd_p0_data;
  wire[31:0]	rf_rd_p1_data;
  wire [31:0]   opr_a;
  wire [31:0]   opr_b;
  wire [3:0]	op_sel;
  wire [31:0]	ex_res;
  wire		    ex_dmem_valid;
  wire[31:0]    ex_dmem_addr;
  wire[31:0]    ex_dmem_wdata;
  wire	  	    ex_dmem_wnr;
  logic[31:0]   dmem_data;
  logic		    dmem_done;
  logic[31:0]   imm_sign_ext;
  logic 		mem_op;
  
  // Instantiate and connect all the submodules
  assign instr_done = dmem_done | ~mem_op;
  riscv_fetch FETCH (
    .clk				(clk),
    .reset				(reset),
    .instr_done_i		(instr_done),
    .psel_o				(imem_psel_o),
    .penable_o			(imem_penable_o),
    .paddr_o			(imem_paddr_o),
    .pwrite_o			(imem_pwrite_o),
    .pwdata_o			(imem_pwdata_o),
    .pready_i			(imem_pready_i),
    .prdata_i			(imem_prdata_i),
    .if_dec_valid_o		(if_dec_valid),
    .if_dec_instr_o		(if_dec_instr),
    .ex_if_pc_i			(ex_if_pc)
  );
  
  riscv_decode DECODE (
    .if_dec_instr_i		(if_dec_instr),
    .rs1_o				(rs1),
    .rs2_o				(rs2),
    .rd_o				(rd),
    .op_o				(op),
    .funct3_o			(funct3),
    .funct7_o			(funct7),
    .is_r_type_o		(is_r_type),
    .is_i_type_o		(is_i_type),
    .is_s_type_o		(is_s_type),
    .is_b_type_o		(is_b_type),
    .is_u_type_o		(is_u_type),
    .is_j_type_o		(is_j_type),
    .i_type_imm_o		(i_type_imm),
    .s_type_imm_o		(s_type_imm),
    .b_type_imm_o		(b_type_imm),
    .u_type_imm_o		(u_type_imm),
    .j_type_imm_o		(j_type_imm)
  );
  
  assign rf_wr_en = rf_en;
  assign rf_wr_addr = rd;
  assign rf_wr_data = wb_sel[0] ? ex_res :
    wb_sel[1] ? ex_if_pc + 32'h4 :
    dmem_data;
  
  riscv_regfile REGFILE (
    .clk				(clk),
    .reset				(reset),
    .rf_wr_en_i			(rf_wr_en),
    .rf_wr_addr_i		(rf_wr_addr),
    .rf_wr_data_i		(rf_wr_data),  
    .rf_rd_p0_i			(rf_rd_p0),
    .rf_rd_p1_i			(rf_rd_p1),
    .rf_rd_p0_data_o	(rf_rd_p0_data),
    .rf_rd_p1_data_o	(rf_rd_p1_data)
  );
  
  // Sign extend the immediate
  assign imm_sign_ext = (is_i_type) ? {{30{i_type_imm[11]}}, i_type_imm} :
    					(is_s_type) ? {{30{s_type_imm[11]}}, s_type_imm} :
					    (is_b_type) ? {{30{b_type_imm[11]}}, b_type_imm} :
					    (is_u_type) ? {{12{u_type_imm[19]}}, u_type_imm} :
									  {{12{j_type_imm[19]}}, j_type_imm};
  
  // Send the correct data to the ALU
  assign opr_a = op1_sel ? imm_sign_ext : rf_rd_p0_data;
  
  assign opr_b = &op2_sel   ? rf_rd_p1_data :
                 op2_sel[0] ? imm_sign_ext :
                              ex_if_pc; 
  
  riscv_execute EXECUTE (
    .opr_a_i			(opr_a),
    .opr_b_i			(opr_b),
    .op_sel_i			(alu_op),
    .ex_res_o			(ex_res)
  );
  
  assign mem_op = is_s_type | (is_i_type & (op == 7'h3));
  
  assign dmem_valid = if_dec_valid & mem_op;
  assign ex_dmem_addr = ex_res;
  assign ex_dmem_wnr = mem_wr;
  assign ex_dmem_wdata = rf_rd_p0_data;
  
  riscv_dmem DMEM (
    .clk				(clk),
    .reset				(reset),  
    .ex_dmem_valid_i	(ex_dmem_valid), // Mem operation is valid
    .ex_dmem_addr_i		(ex_dmem_addr),
    .ex_dmem_wdata_i	(ex_dmem_wdata),
    .ex_dmem_wnr_i		(ex_dmem_wnr), // 1 - write, 0 - read
    .psel_o				(dmem_psel_o),
    .penable_o			(dmem_penable_o),
    .paddr_o			(dmem_paddr_o),
    .pwrite_o			(dmem_pwrite_o),
    .pwdata_o			(dmem_pwdata_o),
    .pready_i			(dmem_pready_i),
    .prdata_i			(dmem_prdata_i),
    .dmem_data_o		(dmem_data),
    .dmem_done_o		(dmem_done)
  );
  
  riscv_control CONTROL (
    .instr_funct3_i		(funct3),
    .instr_funct7_i		(funct7),
    .instr_op_i			(op),
    .is_r_type_i		(is_r_type),
    .is_i_type_i		(is_i_type),
    .is_s_type_i		(is_s_type),
    .is_b_type_i		(is_b_type),	
    .is_u_type_i		(is_u_type),
    .is_j_type_i		(is_j_type),
    .pc_sel_o			(pc_sel),
    .op1_sel_o			(op1_sel),
    .op2_sel_o			(op2_sel),
    .wb_sel_o			(wb_sel),
    .pc4_sel_o			(pc4_sel),
    .mem_wr_o			(mem_wr),
    .cpr_en_o			(/* TODO */),
    .rf_en_o			(rf_en),
    .alu_op_o			(alu_op)
  );
  
endmodule
