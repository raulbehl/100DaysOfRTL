`include "day4_test.sv"
module day41_tb();
  
  // Instantiate the interface
  day4_if intf();
  
  // Instantiate the RTL
  day4 DAY4 (
    .a_i		(intf.a),
    .b_i		(intf.b),
    .op_i		(intf.op),
    .alu_o		(intf.alu)
  );
  
  // Create the test class
  day4_test test;
  
  initial begin
    test = new;
    test.env.vif = intf;
    test.run();
    $finish();
  end
  
  // Dump VCD
  initial begin
    $dumpfile("day41.vcd");
    $dumpvars(0, day41_tb);
  end
  
endmodule