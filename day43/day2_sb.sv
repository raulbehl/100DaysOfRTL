// Scoreboard

`ifndef DAY2_SB
`define DAY2_SB

`include "day2_item.sv"
class day2_sb;

  // Mailbox to get transaction from monitor
  // Used for sampling the outputs from RTL
  mailbox sb_mx;
  
  virtual day2_if vif;
  
  logic q_norst = 0;
  logic q_syncrst = 0;
  logic q_asyncrst = 0;
  
  task run();
    // Item to get from mailbox
    day2_item mon_item;
    day2_item drv_item;
    $display("%t [SCOREBOARD] Starting now...", $time);
    forever begin
      @(posedge vif.clk);
      sb_mx.get(mon_item);
      // Print the received item
      mon_item.print("SCOREBOARD-MON");

      // Compare the item
      if (vif.reset) begin
        q_syncrst 	<= 1'b0;
        q_asyncrst	= 1'b0;
      end else begin
        q_syncrst <= vif.d;
        q_asyncrst <= vif.d;
        q_norst <= vif.d;
      end
      if (mon_item.q_syncrst !== q_syncrst) begin
        $fatal(1, "Sync reset o/p  do not match. Expected: %b Got: %b", q_syncrst, mon_item.q_syncrst);
      end
      if (mon_item.q_asyncrst !== q_asyncrst) begin
        $fatal(1, "Async reset o/p  do not match. Expected: %b Got: %b", q_asyncrst, mon_item.q_asyncrst);
      end
      if (mon_item.q_norst !== q_norst) begin
        $fatal(1, "No reset o/p  do not match. Expected: %b Got: %b", q_norst, mon_item.q_norst);
      end
    end

  endtask

endclass

`endif
