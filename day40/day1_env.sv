// Environment

`ifndef DAY1_ENV
`define DAY1_ENV

`include "day1_item.sv"
`include "day1_driver.sv"
`include "day1_monitor.sv"
`include "day1_sb.sv"
class day1_env;

  // Define every testbench component
  day1_driver   drv;
  day1_monitor  mon;
  day1_sb       sb;

  mailbox       sb_mx;

  // Virtual interface
  virtual day1_if vif;

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
