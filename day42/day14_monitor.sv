// Monitor

`ifndef DAY14_MONITOR
`define DAY14_MONITOR

`include "day14_item.sv"
class day14_monitor;
  
  // Item
  day14_item item;
  // Virtual interface
  virtual day14_if vif;
  // Mailbox to send transactions to scoreboard
  mailbox sb_mx;

  task run();
    $display("%t [MONITOR] Starting now....", $time);

    forever begin
      item = new;
      // Wait for some time before sampling from the virtual interface
      #5;
      // Read the signals
      item.req    = vif.req;
      item.gnt    = vif.gnt;

      // Print the item
      item.print("MONITOR");
      // Put the item in the mailbox
      sb_mx.put(item);
    end

  endtask

endclass

`endif
