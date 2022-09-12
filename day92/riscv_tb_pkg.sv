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

endpackage

`endif