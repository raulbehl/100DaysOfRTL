// Test
`ifndef DAY2_TEST
`define DAY2_TEST

`include "day2_intf.sv"
`include "day2_env.sv"

class day2_test;

  day2_env env;
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
    day2_item item;

    // Wait for reset to be deasserted
	@(negedge env.vif.reset);
    @(posedge env.vif.clk);
    for (int i=0; i<512; i++) begin
      $display("%t [TEST] Starting stimulus...", $time);
      // Wait for some time before starting next item
      @(posedge env.vif.clk);
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
