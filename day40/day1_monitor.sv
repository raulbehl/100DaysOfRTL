// Monitor

`ifndef DAY1_MONITOR
`define DAY1_MONITOR

`include "day1_item.sv"
class day1_monitor;
  
  // Item
  day1_item item;
  // Virtual interface
  virtual day1_if vif;
  // Mailbox to send transactions to scoreboard
  mailbox sb_mx;

  task run();
    $display("%t [MONITOR] Starting now....", $time);

    forever begin
      item = new;
      // Wait for some time before sampling from the virtual interface
      #6;
      // Read the signals
      item.a    = vif.a;
      item.b    = vif.b;
      item.sel  = vif.sel;
      item.y	= vif.y;

      // Print the item
      item.print("MONITOR");
      // Put the item in the mailbox
      sb_mx.put(item);
    end

  endtask

endclass

`endif
