// Verify fifo using queues

module day27_tb ();
  
  parameter DEPTH 	= 8;
  parameter DATA_W 	= 4;
  
  logic				clk;
  logic				reset;
  
  logic				push_i;
  logic[DATA_W-1:0]	push_data_i;
  
  logic				pop_i;
  logic[DATA_W-1:0]	pop_data_o;
  
  logic				full_o;
  logic				empty_o;
  
  // Model fifo using queue
  logic [DATA_W-1:0] fifo[$];
  
  bit push;
  bit pop;
  bit[DATA_W-1:0] pop_data;
  
  // Instantiate the RTL
  day19 #(.DEPTH(DEPTH), .DATA_W(DATA_W)) DAY19 (.*);
  
  // Generate clk
  always begin
    clk = 1'b1;
    #5;
    clk = 1'b0;
    #5;
  end
  
  // Generate and drive stimulus
  initial begin
    reset 	= 1'b1;
    push_i 	= 1'b0;
    pop_i 	= 1'b0;
    push	= 1'b0;
    pop		= 1'b0;
    @(posedge clk);
    reset <= 1'b0;
    repeat (3) @(posedge clk);
    for (int i=0; i<512; i++) begin
      @(posedge clk);
      // Drive random values to push_data
      push_data_i = $urandom_range(0, 15);
      // Randomise push and pop
      push = $urandom_range(0, 3)%2;
      pop = $urandom_range(0, 8)%2;
      // Do not push if full
      if (fifo.size() == DEPTH) push = 0;
      // Do not pop if empty
      if (fifo.size() == 0) pop = 0;
      // Drive RTL
      push_i = push;
      pop_i = pop;
      // Check the values on negedge
      @(negedge clk);
      // Push back data on a push
      if (push_i) fifo.push_back(push_data_i);
      if (pop_i) begin
        // Pop data on pop
        pop_data = fifo.pop_front();
        // Compare with RTL
        if (pop_data_o !== pop_data) begin
          $fatal(1, "Pop data doesn't match. Expected: 0x%8x, Got: 0x%8x", pop_data, pop_data_o);
          $finish();
        end
      end
    end
    $finish();
  end
  
  initial begin
    $dumpfile("day27.vcd");
    $dumpvars(0, day27_tb);
  end
  
endmodule
