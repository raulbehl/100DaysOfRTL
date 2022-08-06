// Driver

`ifndef DAY10_DRIVER
`define DAY10_DRIVER

`include "day10_item.sv"
class day10_driver;

  // Virtual interface
  virtual day10_if vif;

  // Mailbox to get the randomized transaction
  mailbox drv_mx;

  // Task to drive transactions
  task run();
    $display("%t [DRIVER] Starting now...", $time);
	vif.cb.load <= '0;
    // Always try to send transaction to the interface
    forever begin
      // Item object
      day10_item item;
      // Wait for some time before sending the next transaction
      @(posedge vif.clk);

      $display("%t [DRIVER] Waiting for the item", $time);
      drv_mx.get(item);
      // Print the received item
      item.print("DRIVER");
      // Drive the transaction
      vif.cb.load   	<= item.load;
      vif.cb.load_val   <= item.load_val;
    end
  endtask

endclass

`endif
