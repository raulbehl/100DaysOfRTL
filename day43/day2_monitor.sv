// Monitor

`ifndef DAY2_MONITOR
`define DAY2_MONITOR

`include "day2_item.sv"
class day2_monitor;
  
  // Item
  day2_item item;
  // Virtual interface
  virtual day2_if vif;
  // Mailbox to send transactions to scoreboard
  mailbox sb_mx;

  task run();
    $display("%t [MONITOR] Starting now....", $time);

    forever begin
      item = new;
      // Wait for some time before sampling from the virtual interface
      @(posedge vif.clk);
      // Read the signals
      item.d    		= vif.d;
      item.q_norst  	= vif.cb.q_norst;
      item.q_syncrst	= vif.cb.q_syncrst;
      item.q_asyncrst	= vif.cb.q_asyncrst;

      // Print the item
      item.print("MONITOR");
      // Put the item in the mailbox
      sb_mx.put(item);
    end

  endtask

endclass

`endif
