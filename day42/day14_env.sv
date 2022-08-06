// Environment

`ifndef DAY14_ENV
`define DAY14_ENV

`include "day14_item.sv"
`include "day14_driver.sv"
`include "day14_monitor.sv"
`include "day14_sb.sv"
class day14_env;

  // Define every testbench component
  day14_driver   drv;
  day14_monitor  mon;
  day14_sb       sb;

  mailbox       sb_mx;

  // Virtual interface
  virtual day14_if vif;

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
