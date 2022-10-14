`ifndef RISCV_TB_PKG
`define RISCV_TB_PKG

package riscv_tb_pkg;

  typedef enum logic [2:0] {
    R_TYPE = 3'h0,
    I_TYPE = 3'h1,
    S_TYPE = 3'h2,
    B_TYPE = 3'h3,
    U_TYPE = 3'h4,
    J_TYPE = 3'h5
  } instr_type_t;

  typedef enum logic [2:0] {
    ADD  = 3'h0,
    SLL  = 3'h1,
    SLT  = 3'h2,
    SLTU = 3'h3,
    XOR  = 3'h4,
    SRL  = 3'h5,
    OR   = 3'h6,
    AND  = 3'h7
  } funct3_r_type_t;

  typedef enum logic [2:0] {
    ADDI  = 3'h0,
    SLLI  = 3'h1,
    SLTI  = 3'h2,
    SLTIU = 3'h3,
    XORI  = 3'h4,
    SRLI  = 3'h5,
    ORI   = 3'h6,
    ANDI  = 3'h7
  } funct3_i_type_t;

  typedef enum logic [2:0] {
    LB  = 3'h0,
    LH  = 3'h1,
    LW  = 3'h2,
    LBU = 3'h4,
    LHU = 3'h5
  } funct3_lw_type_t;

  typedef enum logic [2:0] {
    SB  = 3'h0,
    SH  = 3'h1,
    SW  = 3'h2
  } funct3_s_type_t;

  typedef enum logic [2:0] {
    BEQ  = 3'h0,
    BNE  = 3'h1,
    BLT  = 3'h4,
    BGE  = 3'h5,
    BLTU = 3'h6,
    BGEU = 3'h7
  } funct3_b_type_t;

endpackage

`endif