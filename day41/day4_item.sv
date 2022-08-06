// Transaction item

`ifndef DAY4_ITEM
`define DAY4_ITEM

`include "day4_pkg.sv"

import day4_pkg::*;
class day4_item;
  
  rand bit[7:0] a;
  rand bit[7:0] b;
  rand alu_op_t op;
  bit[7:0]      alu;

  // Helper function to print transaction
  function void print (string component);
    $display("%t [%s] a: 0x%2x b: 0x%2x op: %b alu: 0x%2x", $time, component, a, b, op, alu);
  endfunction

endclass

`endif
