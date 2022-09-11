module riscv_decode (
  input		logic[31:0] if_dec_instr_i,
  output	logic[4:0]	rs1_o,
  output	logic[4:0]  rs2_o,
  output	logic[4:0]  rd_o,
  output 	logic[6:0]	op_o,
  output	logic[2:0]  funct3_o,
  output	logic[6:0]  funct7_o,
  output	logic		is_r_type_o,
  output	logic		is_i_type_o,
  output	logic		is_s_type_o,
  output	logic		is_b_type_o,
  output	logic		is_u_type_o,
  output	logic		is_j_type_o,
  output    logic[11:0] i_type_imm_o,
  output    logic[11:0] s_type_imm_o,
  output    logic[11:0] b_type_imm_o,
  output    logic[19:0] u_type_imm_o,
  output    logic[19:0] j_type_imm_o
);
  
  assign rd_o 		= if_dec_instr_i[11:7];
  assign rs1_o		= if_dec_instr_i[19:15];
  assign rs2_o		= if_dec_instr_i[24:20];
  assign op_o		= if_dec_instr_i[6:0];
  assign funct3_o	= if_dec_instr_i[14:12];
  assign funct7_o	= if_dec_instr_i[31:25];
  
  // Decode the type of the instruction
  always_comb begin
    is_r_type_o = 1'b0;
    is_i_type_o = 1'b0;
    is_s_type_o = 1'b0;
    is_b_type_o = 1'b0;
    is_u_type_o = 1'b0;
    is_j_type_o = 1'b0;
    case (op_o)
      7'h33 : is_r_type_o = 1'b1;
      // I-type data processing
      // I-type LW
      // JALR
      7'h13,
      7'h03,
      7'h67 : is_i_type_o = 1'b1;
      7'h23 : is_s_type_o = 1'b1;
      7'h63 : is_b_type_o = 1'b1;
      7'h6F : is_j_type_o = 1'b1;
    endcase
  end
  
  assign i_type_imm_o[11:0] = if_dec_instr_i[31:20];
  assign s_type_imm_o[11:0] = {if_dec_instr_i[31:25], if_dec_instr_i[11:7]};
  assign b_type_imm_o[11:0] = {if_dec_instr_i[31], if_dec_instr_i[7], if_dec_instr_i[30:25],
                               if_dec_instr_i[11:8]};
  assign u_type_imm_o[19:0] = if_dec_instr_i[31:12];
  assign j_type_imm_o[19:0] = {if_dec_instr_i[31], if_dec_instr_i[19:12], if_dec_instr_i[20],
                               if_dec_instr_i[30:21]};
  
endmodule