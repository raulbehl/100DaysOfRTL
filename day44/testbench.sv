`include "day14_test.sv"
module day44_tb();
  
  // Define the NUM_PORTS parameter
  localparam NUM_PORTS = 16;
  
  // Instantiate the interface
  day14_if #(.NUM_PORTS(NUM_PORTS)) intf();
  
  // Instantiate the RTL
  day14 #(.NUM_PORTS(NUM_PORTS)) DAY14 (
    .req_i		(intf.req),
    .gnt_o		(intf.gnt)
  );
  
  // Create the test class
  day14_test #(.NUM_PORTS(NUM_PORTS)) test;
  
  initial begin
    test = new;
    test.env.vif = intf;
    test.run();
    $finish();
  end
  
  // Dump VCD
  initial begin
    $dumpfile("day44.vcd");
    $dumpvars(0, day44_tb);
  end
  
endmodule