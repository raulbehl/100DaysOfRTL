// Simple TB

module day5_tb ();

  logic clk;
  logic reset;

  logic [7:0] cnt_o;

  day5 DAY5 (.*);

  always begin
    clk = 1'b0;
    #5;
    clk = 1'b1;
    #5;
  end

  initial begin
    reset <= 1'b1;
    @(posedge clk);
    @(posedge clk);
    reset <= 1'b0;
    for (int i=0; i<128; i++)
      @(posedge clk);
    $finish();
  end

  initial begin
    $dumpfile("day5.vcd");
    $dumpvars(0, day5_tb);
  end
  
endmodule
