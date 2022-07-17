// TB

module day23_tb ();
  
  logic		clk;
  logic		reset;
  
  logic[1:0]	cmd_i;
  
  // Instantiate the interface
  day23 day23_if (
    .clk		(clk),
    .reset		(reset)
  );
  
  // Instantiate APB master RTL
  day16 apb_master (
    .clk		(clk),
    .reset		(reset),
    .cmd_i		(cmd_i),
    .apb_if		(day23_if.apb_master)
  );
  
  // Generate clock
  always begin
    clk = 1'b0;
    #5;
    clk = 1'b1;
    #5;
  end

  int wait_cycles;
  // Generate pready
  always begin
    day23_if.pready = 1'b0;
    wait_cycles = $urandom_range (1, 10);
    while (wait_cycles) begin
      @(posedge clk);
      wait_cycles--;
    end
    day23_if.pready= 1'b1;
    @(posedge clk);
  end

  // Generate the stimulus
  initial begin
    reset <= 1'b1;
    cmd_i <= 2'b00;
    day23_if.prdata <= 32'h0;
    @(posedge clk);
    reset <= 1'b0;
    @(posedge clk);
    @(posedge clk);
    for (int i=0; i<10; i++) begin
      cmd_i <= i%2 ? 2'b10 : 2'b01;
      day23_if.prdata <= $urandom_range(0, 4'hF);
      // Wait for pready to be asserted
      while (~day23_if.pready | ~day23_if.psel) @(posedge clk);
      @(posedge clk);
    end
    $finish();
  end

  // Dump VCD
  initial begin
    $dumpfile("day23.vcd");
    $dumpvars(0, day23_tb);
  end

  
endmodule
