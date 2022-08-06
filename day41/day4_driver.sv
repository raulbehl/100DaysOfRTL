// Driver

`ifndef DAY4_DRIVER
`define DAY4_DRIVER

`include "day4_item.sv"
class day4_driver;

  // Virtual interface
  virtual day4_if vif;

  // Mailbox to get the randomized transaction
  mailbox drv_mx;

  // Task to drive transactions
  task run();
    $display("%t [DRIVER] Starting now...", $time);

    // Always try to send transaction to the interface
    forever begin
      // Item object
      day4_item item;

      $display("%t [DRIVER] Waiting for the item", $time);
      drv_mx.get(item);
      // Print the received item
      item.print("DRIVER");
      // Drive the transaction
      vif.a   <= item.a;
      vif.b   <= item.b;
      vif.op  <= item.op;
      // Wait for some time before sending the next transaction
      #5;
    end
  endtask

endclass

`endif
