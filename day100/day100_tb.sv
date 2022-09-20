module day100_tb ();

  localparam MAX_CYCLES_PER_CHAR = 500;

  logic clk;
  logic reset;
  logic [9:0] character_i;
  logic start_i;
  // Must be in all CAPS
  string str = "100DAYSOFRTL";

  day100 #(MAX_CYCLES_PER_CHAR) DAY100(.*);

  always begin
    clk = 1'b1;
    #1;
    clk = 1'b0;
    #1;
  end

  initial begin
    reset = 1'b1;
    character_i = '0;
    @(posedge clk);
    reset = 1'b0;
    start_i = 1'b1;
    for (int k=0; k<str.len(); k++) begin
      character_i = 10'(str[k]);
      for (int i=0; i<MAX_CYCLES_PER_CHAR; i++) begin
        @(posedge clk);
      end
    end
    $finish();
  end

  // Dump waveforms
  initial begin
    $dumpfile("day100.vcd");
    $dumpvars(0, day100_tb);
  end

endmodule
