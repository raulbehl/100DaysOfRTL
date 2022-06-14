// DFF TB

module day2_tb ();

  logic      clk;
  logic      reset;

  logic      d_i;

  logic      q_norst_o;
  logic      q_syncrst_o;
  logic      q_asyncrst_o;

  day2 DAY2 (.*);

  // Generate clk
  always begin
    clk = 1'b1;
    #5;
    clk = 1'b0;
    #5;
  end

  // Stimulus
  initial begin
    reset = 1'b1;
    d_i = 1'b0;
    @(posedge clk);
    reset = 1'b0;
    @(posedge clk);
    d_i = 1'b1;
    @(posedge clk);
    @(posedge clk);
    @(negedge clk);
    reset = 1'b1;
    @(posedge clk);
    @(posedge clk);
    reset = 1'b0;
    @(posedge clk);
    @(posedge clk);
    $finish();
  end

  // Dump VCD
  initial begin
    $dumpfile("day2.vcd");
    $dumpvars(0, day2_tb);
  end
  

endmodule
