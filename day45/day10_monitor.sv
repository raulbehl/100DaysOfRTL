// Monitor

`ifndef DAY10_MONITOR
`define DAY10_MONITOR

`include "day10_item.sv"
class day10_monitor;
  
  // Item
  day10_item item;
  // Virtual interface
  virtual day10_if vif;
  // Mailbox to send transactions to scoreboard
  mailbox sb_mx;

  task run();
    // Wait for reset to be deasserted
    @(negedge vif.reset);
    $display("%t [MONITOR] Starting now....", $time);

    forever begin
      item = new;
      // Wait for some time before sampling from the virtual interface
      @(posedge vif.clk);
      // Read the signals
      item.load    		= vif.load;
      item.load_val    	= vif.load_val;
      item.count    	= vif.cb.count;

      // Print the item
      item.print("MONITOR");
      // Put the item in the mailbox
      sb_mx.put(item);
    end

  endtask

endclass

`endif
