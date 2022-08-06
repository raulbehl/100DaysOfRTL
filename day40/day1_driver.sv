// Driver

`ifndef DAY1_DRIVER
`define DAY1_DRIVER

`include "day1_item.sv"
class day1_driver;

  // Virtual interface
  virtual day1_if vif;

  // Mailbox to get the randomized transaction
  mailbox drv_mx;

  // Task to drive transactions
  task run();
    $display("%t [DRIVER] Starting now...", $time);

    // Always try to send transaction to the interface
    forever begin
      // Item object
      day1_item item;

      $display("%t [DRIVER] Waiting for the item", $time);
      drv_mx.get(item);
      // Print the received item
      item.print("DRIVER");
      // Drive the transaction
      vif.a   <= item.a;
      vif.b   <= item.b;
      vif.sel <= item.sel;
      // Wait for some time before sending the next transaction
      #5;
    end
  endtask

endclass

`endif
