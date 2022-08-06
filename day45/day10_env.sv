// Environment

`ifndef DAY10_ENV
`define DAY10_ENV

`include "day10_item.sv"
`include "day10_driver.sv"
`include "day10_monitor.sv"
`include "day10_sb.sv"
class day10_env;

  // Define every testbench component
  day10_driver   drv;
  day10_monitor  mon;
  day10_sb       sb;

  mailbox       sb_mx;

  // Virtual interface
  virtual day10_if vif;

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
