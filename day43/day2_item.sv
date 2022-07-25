// Transaction item

`ifndef DAY2_ITEM
`define DAY2_ITEM

class day2_item;

  rand bit d;
  bit q_norst;
  bit q_syncrst;
  bit q_asyncrst;

  // Helper function to print transaction
  function void print (string component);
    $display("%t [%s] d: %b q_norst: %b q_syncrst: %b q_asyncrst: %b", $time, component, d, q_norst, q_syncrst, q_asyncrst);
  endfunction

endclass

`endif
