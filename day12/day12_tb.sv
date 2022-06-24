module day12_tb ();

  logic         clk;
  logic         reset;
  logic         x_i;
  logic         det_o;

  day12 DAY12 (.*);

  always begin
    clk = 1'b1;
    #5;
    clk = 1'b0;
    #5;
  end

  logic [11:0] seq = 12'b1110_1101_1011;

  initial begin
    reset <= 1'b1;
    x_i <= 1'b1;
    @(posedge clk);
    reset <= 1'b0;
    @(posedge clk);
    for (int i=0; i<12; i=i+1) begin
      x_i <= seq[i];
      @(posedge clk);
    end
    for (int i=0; i<12; i=i+1) begin
      x_i <= $random%2;
      @(posedge clk);
    end
    $finish();
  end

  initial begin
    $dumpfile("day12.vcd");
    $dumpvars(0, day12_tb);
  end

endmodule
