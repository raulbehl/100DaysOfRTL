// Monitor

`ifndef DAY4_MONITOR
`define DAY4_MONITOR

`include "day4_item.sv"
class day4_monitor;
  
  // Item
  day4_item item;
  // Virtual interface
  virtual day4_if vif;
  // Mailbox to send transactions to scoreboard
  mailbox sb_mx;

  task run();
    $display("%t [MONITOR] Starting now....", $time);

    forever begin
      item = new;
      // Wait for some time before sampling from the virtual interface
      #5;
      // Read the signals
      item.a    = vif.a;
      item.b    = vif.b;
      item.op   = alu_op_t'(vif.op);
      item.alu	= vif.alu;

      // Print the item
      item.print("MONITOR");
      // Put the item in the mailbox
      sb_mx.put(item);
    end

  endtask

endclass

`endif
