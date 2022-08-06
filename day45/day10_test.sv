// Test
`ifndef DAY10_TEST
`define DAY10_TEST

`include "day10_intf.sv"
`include "day10_env.sv"

class day10_test;

  day10_env env;
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
    day10_item item;

    // Wait for reset to be deasserted
	@(negedge env.vif.reset);
    for (int i=0; i<512; i++) begin
      // Wait for some time before starting next item
      @(posedge env.vif.clk);
      $display("%t [TEST] Starting stimulus...", $time);
      item = new;
      // Randomize the transaction
      void'(item.randomize());
      // Send the transaction to driver
      drv_mx.put(item);
    end
    // Test passed if we reach here
    $display("TEST PASSED!");
  endtask

endclass
`endif
