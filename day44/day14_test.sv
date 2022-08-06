// Test
`ifndef DAY14_TEST
`define DAY14_TEST

`include "day14_intf.sv"
`include "day14_env.sv"

class day14_test #(parameter NUM_PORTS=8);

  day14_env #(.NUM_PORTS(NUM_PORTS)) env;
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
    day14_item #(.NUM_PORTS(NUM_PORTS)) item;

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
    // Test passed if we reach here
    $display("TEST PASSED!");
  endtask

endclass
`endif
