// Test
`ifndef DAY1_TEST
`define DAY1_TEST

`include "day1_intf.sv"
`include "day1_env.sv"

class day1_test;

  day1_env env;
  mailbox  drv_mx;

  function new();
    env = new;
    drv_mx = new();
  endfunction

  task run();
    env.drv.drv_mx = drv_mx;
    fork
      env.run();
    join_none
    // Generate stimulus
    gen_stimulus();
  endtask

  task gen_stimulus();
    day1_item item;

    for (int i=0; i<512; i++) begin
      $display("%t [TEST] Starting stimulus...", $time);
      item = new;
      // Randomize the transaction
      void'(item.randomize());
      // Send the transaction to driver
      drv_mx.put(item);
      // Wait for some time before starting next item
      #7;
    end
  endtask

endclass
`endif
