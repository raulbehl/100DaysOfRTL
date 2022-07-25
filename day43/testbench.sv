`include "day2_test.sv"
module day43_tb();
  
  logic		clk;
  logic		reset;
  
  // Instantiate the interface
  day2_if intf(clk, reset);
  
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
  day2 DAY2 (
    .clk			(clk),
    .reset			(reset),
    .d_i			(intf.d),
    .q_norst_o		(intf.q_norst),
    .q_syncrst_o	(intf.q_syncrst),
    .q_asyncrst_o	(intf.q_asyncrst)
  );
  
  // Create the test class
  day2_test test;
  
  initial begin
    test = new;
    test.env.vif = intf;
    test.run();
    $finish();
  end
  
  // Dump VCD
  initial begin
    $dumpfile("day43.vcd");
    $dumpvars(0, day43_tb);
  end
  
endmodule