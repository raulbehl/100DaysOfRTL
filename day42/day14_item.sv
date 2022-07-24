// Transaction item

`ifndef DAY14_ITEM
`define DAY14_ITEM

class day14_item;

  rand bit[3:0] req;
  bit[3:0] gnt;

  // Helper function to print transaction
  function void print (string component);
    $display("%t [%s] req: 0x%2x gnt: 0x%2x", $time, component, req, gnt);
  endfunction

endclass

`endif
