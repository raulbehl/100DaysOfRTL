// Driver

`ifndef DAY14_DRIVER
`define DAY14_DRIVER

`include "day14_item.sv"
class day14_driver #(parameter NUM_PORTS=8);

  // Virtual interface
  virtual day14_if #(.NUM_PORTS(NUM_PORTS)) vif;

  // Mailbox to get the randomized transaction
  mailbox drv_mx;

  // Task to drive transactions
  task run();
    $display("%t [DRIVER] Starting now...", $time);

    // Always try to send transaction to the interface
    forever begin
      // Item object
      day14_item #(.NUM_PORTS(NUM_PORTS)) item;

      $display("%t [DRIVER] Waiting for the item", $time);
      drv_mx.get(item);
      // Print the received item
      item.print("DRIVER");
      // Drive the transaction
      vif.req   <= item.req;
      // Wait for some time before sending the next transaction
      #5;
    end
  endtask

endclass

`endif
