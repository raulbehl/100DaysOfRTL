// Driver

`ifndef DAY2_DRIVER
`define DAY2_DRIVER

`include "day2_item.sv"
class day2_driver;

  // Virtual interface
  virtual day2_if vif;

  // Mailbox to get the randomized transaction
  mailbox drv_mx;

  // Task to drive transactions
  task run();
    $display("%t [DRIVER] Starting now...", $time);
	vif.cb.d <= '0;
    // Always try to send transaction to the interface
    forever begin
      // Item object
      day2_item item;
      // Wait for some time before sending the next transaction
      @(posedge vif.clk);

      $display("%t [DRIVER] Waiting for the item", $time);
      drv_mx.get(item);
      // Print the received item
      item.print("DRIVER");
      // Drive the transaction
      vif.cb.d   <= item.d;
    end
  endtask

endclass

`endif
