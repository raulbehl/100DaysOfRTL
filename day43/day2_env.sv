// Environment

`ifndef DAY2_ENV
`define DAY2_ENV

`include "day2_item.sv"
`include "day2_driver.sv"
`include "day2_monitor.sv"
`include "day2_sb.sv"
class day2_env;

  // Define every testbench component
  day2_driver   drv;
  day2_monitor  mon;
  day2_sb       sb;

  mailbox       sb_mx;

  // Virtual interface
  virtual day2_if vif;

  // Instantiate all the components
  function new();
    drv   = new;
    mon   = new;
    sb    = new;
    sb_mx = new();
  endfunction

  // Fork run for every component
  task run();
    // Point to the env's vif
    drv.vif   = vif;
    mon.vif   = vif;
    sb.vif	  = vif;
    // Connect monitor and scoreboard mailbox
    mon.sb_mx = sb_mx;
    sb.sb_mx  = sb_mx;

    fork
      drv.run();
      mon.run();
      sb.run();
    join_any
  endtask

endclass

`endif
