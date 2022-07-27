// Transaction item

`ifndef DAY10_ITEM
`define DAY10_ITEM

class day10_item;

  rand bit load;
  rand bit[3:0] load_val;
  bit [3:0] count;

  // Helper function to print transaction
  function void print (string component);
    $display("%t [%s] load: %b load_val: 0x%4x count: 0x%4x", $time, component, load, load_val, count);
  endfunction

endclass

`endif
