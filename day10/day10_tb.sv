module day10_tb ();

  logic          clk;
  logic          reset;
  logic          load_i;
  logic[3:0]     load_val_i;

  logic[3:0]     count_o;

  day10 DAY10 (.*);

  // Clock
  always begin
    clk = 1'b1;
    #5;
    clk = 1'b0;
    #5;
  end

  int cycles;
  initial begin
    reset <= 1'b1;
    load_i <= 1'b0;
    load_val_i <= 4'h0;
    @(posedge clk);
    reset <= 1'b0;
    for (int i=0; i<3; i=i+1) begin
      load_i <= 1;
      load_val_i <= 3*i;
      cycles = 4'hF - load_val_i[3:0];
      @(posedge clk);
      load_i <= 0;
      while (cycles) begin
        cycles = cycles - 1;
        @(posedge clk);
      end
    end
    $finish();
  end

  initial begin
    $dumpfile("day10.vcd");
    $dumpvars(2, day10_tb);
  end

endmodule
