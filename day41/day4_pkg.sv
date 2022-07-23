`ifndef DAY4_PKG
`define DAY4_PKG
package day4_pkg;

typedef enum logic[2:0] {
  OP_ADD,
  OP_SUB,
  OP_SLL,
  OP_LSR,
  OP_AND,
  OP_OR,
  OP_XOR,
  OP_EQL
} alu_op_t;

endpackage
`endif