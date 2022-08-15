module day64_tb ();

  localparam MAX_CYCLES = 5000;

  logic clk;
  logic reset;

  day64 #(MAX_CYCLES) TIRANGA (.*);

  always begin
    clk = 1'b1;
    #5;
    clk = 1'b0;
    #5;
  end

  initial begin
    reset = 1'b1;
    @(posedge clk);
    reset = 1'b0;
    for (int i=0; i<MAX_CYCLES; i++) begin
      @(posedge clk);
    end
    $finish();
  end

  // Dump waveforms
  initial begin
    $dumpfile("day64.vcd");
    $dumpvars(0, day64_tb);
  end

endmodule
