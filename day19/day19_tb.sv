// Fifo TB

module day19_tb ();

  parameter DATA_W = 16;
  parameter DEPTH  = 8;

  logic              clk;
  logic              reset;

  logic              push_i;
  logic[DATA_W-1:0]  push_data_i;

  logic              pop_i;
  logic[DATA_W-1:0]  pop_data_o;

  logic              full_o;
  logic              empty_o;

  // Instantiate the RTL
  day19 #(.DEPTH(DEPTH), .DATA_W(DATA_W)) DAY19 (.*);

  // Generate clock
  always begin
    clk = 1'b1;
    #5;
    clk = 1'b0;
    #5;
  end

  // Drive stimulus
  initial begin
    reset   <= 1'b1;
    push_i  <= 1'b0;
    pop_i   <= 1'b0;
    @(posedge clk);
    reset   <= 1'b0;
    @(posedge clk);
    @(posedge clk);
    // Make fifo full
    for (int i=0; i<DEPTH; i++) begin
      push_i      <= 1'b1;
      push_data_i <= $urandom_range(0, 2**DATA_W-1);
      @(posedge clk);
    end
    push_i <= 1'b0;
    @(posedge clk);
    @(posedge clk);
    // Make fifo empty
    for (int i=0; i<DEPTH; i++) begin
      pop_i      <= 1'b1;
      @(posedge clk);
    end
    pop_i <= 1'b0;
    @(posedge clk);
    @(posedge clk);
    push_i      <= 1'b1;
    push_data_i <= $urandom_range(0, 2**DATA_W-1);
    @(posedge clk);
    push_i      <= 1'b0;
    // Push and pop both
    for (int i=0; i<DEPTH; i++) begin
      push_i      <= 1'b1;
      pop_i       <= 1'b1;
      push_data_i <= $urandom_range(0, 2**DATA_W-1);
      @(posedge clk);
    end
    pop_i <= 1'b0;
    push_i<= 1'b0;
    @(posedge clk);
    @(posedge clk);
    $finish();
  end

  // Dump vcd
  initial begin
    $dumpfile("day19.vcd");
    $dumpvars(0, day19_tb);
  end

endmodule
