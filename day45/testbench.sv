`include "day10_test.sv"
module day44_tb();
  
  logic		clk;
  logic		reset;
  
  // Instantiate the interface
  day10_if intf(clk, reset);
  
  // Generate clock
  always begin
    clk = 1'b0;
    #5;
    clk = 1'b1;
    #5;
  end
  
  // Reset sequence
  initial begin
    reset = 1'b1;
    repeat(3) @(posedge clk);
    reset = 1'b0;
  end
  
  // Instantiate the RTL
  day10 DAY10 (
    .clk			(clk),
    .reset			(reset),
    .load_i			(intf.load),
    .load_val_i		(intf.load_val),
    .count_o		(intf.count)
  );
  
  // Create the test class
  day10_test test;
  
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