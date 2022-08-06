// Transaction item

`ifndef DAY14_ITEM
`define DAY14_ITEM

class day14_item #(parameter NUM_PORTS=8);

  rand bit[NUM_PORTS-1:0] req;
  bit[NUM_PORTS-1:0] gnt;

  // Helper function to print transaction
  function void print (string component);
    $display("%t [%s] req: 0x%8x gnt: 0x%8x", $time, component, req, gnt);
  endfunction

endclass

`endif
