// Transaction item

`ifndef DAY1_ITEM
`define DAY1_ITEM

class day1_item;

  rand bit[7:0] a;
  rand bit[7:0] b;
  rand bit      sel;
  bit[7:0]      y;

  // Helper function to print transaction
  function void print (string component);
    $display("%t [%s] a: 0x%2x b: 0x%2x sel: %b y: 0x%2x", $time, component, a, b, sel, y);
  endfunction

endclass

`endif
