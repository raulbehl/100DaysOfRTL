`include "day1_test.sv"
module day40_tb();
  
  // Instantiate the interface
  day1_if intf();
  
  // Instantiate the RTL
  day1 DAY1 (
    .a_i		(intf.a),
    .b_i		(intf.b),
    .sel_i		(intf.sel),
    .y_o		(intf.y)
  );
  
  // Create the test class
  day1_test test;
  
  initial begin
    test = new;
    test.env.vif = intf;
    test.run();
    $finish();
  end
  
  // Dump VCD
  initial begin
    $dumpfile("day40.vcd");
    $dumpvars(0, day40_tb);
  end
  
endmodule