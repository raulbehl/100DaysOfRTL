`include "day14_test.sv"
module day42_tb();
  
  // Instantiate the interface
  day14_if intf();
  
  // Instantiate the RTL
  day14 DAY14 (
    .req_i		(intf.req),
    .gnt_o		(intf.gnt)
  );
  
  // Create the test class
  day14_test test;
  
  initial begin
    test = new;
    test.env.vif = intf;
    test.run();
    $finish();
  end
  
  // Dump VCD
  initial begin
    $dumpfile("day42.vcd");
    $dumpvars(0, day42_tb);
  end
  
endmodule