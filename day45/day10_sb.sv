// Scoreboard

`ifndef DAY10_SB
`define DAY10_SB

`include "day10_item.sv"
class day10_sb;

  // Mailbox to get transaction from monitor
  // Used for sampling the outputs from RTL
  mailbox sb_mx;
  
  virtual day10_if vif;
  
  logic[3:0] count = 0;
  logic[3:0] load_val = 0;
  logic[3:0] nxt_count = 0;
  
  task run();
    // Item to get from mailbox
    day10_item mon_item;
    // Wait for reset to be deasserted
    @(negedge vif.reset);
    $display("%t [SCOREBOARD] Starting now...", $time);
    forever begin
      @(posedge vif.clk);
      sb_mx.get(mon_item);
      // Print the received item
      mon_item.print("SCOREBOARD-MON");

      // Compare the item
      if (mon_item.count !== count) begin
        $fatal(1, "%t Output do not match. Expected: 0x%4x Got: 0x%4x", $time, count, mon_item.count);
      end
      // Store the load val
      if (vif.load) begin
        load_val = vif.load_val;
      end
      if ((count == 4'hF) | vif.load) begin
        count = load_val;
      end else begin
        count = count + 4'h1;
      end
      if (vif.reset) begin
        count = 1'b0;
      end
    end

  endtask

endclass

`endif
