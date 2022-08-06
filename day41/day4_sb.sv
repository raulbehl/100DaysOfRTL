// Scoreboard

`ifndef DAY4_SB
`define DAY4_SB

`include "day4_item.sv"
class day4_sb;

  // Mailbox to get transaction from monitor
  // Used for sampling the outputs from RTL
  mailbox sb_mx;
  // Mailbox to get transaction from driver
  // Used for sampling inputs to the RTL
  mailbox drv_mx;
  bit[7:0] alu_tb;

  task run();
    // Item to get from mailbox
    day4_item mon_item;
    day4_item drv_item;
    $display("%t [SCOREBOARD] Starting now...", $time);
    forever begin
      // Get the item from monitor and driver
      fork
        sb_mx.get(mon_item);
        drv_mx.get(drv_item);
      join
      // Print the received item
      mon_item.print("SCOREBOARD-MON");
      drv_item.print("SCOREBOARD-DRV");

      // Compare the item
      case (drv_item.op)
        OP_ADD: alu_tb = drv_item.a + drv_item.b;
        OP_SUB: alu_tb = drv_item.a - drv_item.b;
        OP_SLL: alu_tb = drv_item.a << drv_item.b[2:0];
        OP_LSR: alu_tb = drv_item.a >> drv_item.b[2:0];
        OP_AND: alu_tb = drv_item.a & drv_item.b;
        OP_OR: alu_tb  = drv_item.a | drv_item.b;
        OP_XOR: alu_tb = drv_item.a ^ drv_item.b;
        OP_EQL: alu_tb = drv_item.a == drv_item.b;
      endcase
      if (mon_item.alu !== alu_tb) begin
        $fatal(1, "%t [SCOREBOARD] Output doesn't match the expected output. Expected: 0x%2x Got: 0x%2x", $time, alu_tb, mon_item.alu);
      end
    end
  endtask

endclass

`endif
