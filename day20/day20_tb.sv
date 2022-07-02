// TB

module day20_tb ();

  logic        clk;
  logic        reset;

  logic        read_i;
  logic        write_i;

  logic        rd_valid_o;
  logic[31:0]  rd_data_o;

  // Instantiate the RTL
  day20 DAY20 (.*);

  // Generate clk
  always begin
    clk = 1'b1;
    #5;
    clk = 1'b0;
    #5;
  end

  // Stimulus
  initial begin
    reset     <= 1'b1;
    read_i    <= 1'b0;
    write_i   <= 1'b0;
    @(posedge clk);
    reset <= 1'b0;
    @(posedge clk);
    for (int i=0; i<512; i++) begin
      read_i    <= $urandom_range(25,50)%2;
      write_i   <= $urandom_range(0, 25)%2;
      @(posedge clk);
    end
    $finish();
  end
  
  // Dump VCD
  initial begin
    $dumpfile("day20.vcd");
    $dumpvars(0, day20_tb);
  end

endmodule
