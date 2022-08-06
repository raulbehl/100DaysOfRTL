// Scoreboard

`ifndef DAY1_SB
`define DAY1_SB

`include "day1_item.sv"
class day1_sb;

  // Mailbox to get transaction from monitor
  mailbox sb_mx;

  task run();
    // Item to get from mailbox
    day1_item item;
    $display("%t [SCOREBOARD] Starting now...", $time);
    forever begin
      // Get the item from mailbox
      sb_mx.get(item);
      // Print the received item
      item.print("SCOREBOARD");

      // Compare the item
      if (item.sel) begin
        if (item.a !== item.y) begin
          $fatal(1, "%t [SCOREBOARD] Output doesn't match the expected output. Expected: 0x%2x Got: 0x%2x", $time, item.a, item.y);
        end
      end else begin
        if (item.b !== item.y) begin
          $fatal(1, "%t [SCOREBOARD] Output doesn't match the expected output. Expected: 0x%2x Got: 0x%2x", $time, item.b, item.y);
        end
      end
    end
  endtask

endclass

`endif
