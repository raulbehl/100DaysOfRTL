// TB for round robin

module day15_tb ();

  logic         clk;
  logic         reset;

  logic [3:0]   req_i;
  logic [3:0]   gnt_o;

  // Instatiate the module
  day15 DAY15 (.*);

  // Clock
  always begin
    clk = 1'b1;
    #5;
    clk = 1'b0;
    #5;
  end

  // Stimulus
  initial begin
    reset <= 1'b1;
    req_i <= 4'h0;
    @(posedge clk);
    reset <= 1'b0;
    @(posedge clk);
    @(posedge clk);
    for (int i =0; i<32; i++) begin
      req_i <= $urandom_range(0, 4'hF);
      @(posedge clk);
    end
    $finish();
  end

  // VCD dump
  initial begin
    $dumpfile("day15.vcd");
    $dumpvars(0, day15_tb);
  end

endmodule
