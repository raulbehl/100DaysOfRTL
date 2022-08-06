// Environment

`ifndef DAY4_ENV
`define DAY4_ENV

`include "day4_item.sv"
`include "day4_driver.sv"
`include "day4_monitor.sv"
`include "day4_sb.sv"
class day4_env;

  // Define every testbench component
  day4_driver   drv;
  day4_monitor  mon;
  day4_sb       sb;

  mailbox       sb_mx;

  // Virtual interface
  virtual day4_if vif;

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
