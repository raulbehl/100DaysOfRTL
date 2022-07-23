// Test
`ifndef DAY4_TEST
`define DAY4_TEST

`include "day4_intf.sv"
`include "day4_env.sv"

class day4_test;

  day4_env env;
  mailbox  drv_mx;

  function new();
    env = new;
    drv_mx = new();
  endfunction

  task run();
    env.drv.drv_mx = drv_mx;
    env.sb.drv_mx = drv_mx;
    fork
      env.run();
    join_none
    // Generate stimulus
    gen_stimulus();
  endtask

  task gen_stimulus();
    day4_item item;

    for (int i=0; i<512; i++) begin
      $display("%t [TEST] Starting stimulus...", $time);
      item = new;
      // Randomize the transaction
      void'(item.randomize());
      // Send the transaction to driver
      drv_mx.put(item);
      // Send transaction to scoreboard for sampling inputs
      drv_mx.put(item);
      // Wait for some time before starting next item
      #5;
    end
    // Test passes if we reach here
    $display("TEST PASSED!");
  endtask

endclass
`endif
