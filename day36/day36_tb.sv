class day28;
  
  rand bit[15:0] req_addr;
  rand bit[31:0] req_wdata;
  
endclass

module day36_tb ();
  
  logic        clk;
  logic        reset;
  logic        req_i;
  logic        req_rnw_i;
  logic[15:0]  req_addr_i;
  logic[31:0]  req_wdata_i;
  logic        req_ready_o;
  logic[31:0]  req_rdata_o;

  // Instatiate the RTL
  day17 DAY17 (.*);

  // Maintain address list as a queue
  bit [15:0] addr_list[$];
  
  // Model TB memory using associative array
  bit [31:0] mem_tb[bit[15:0]];
  
  day28 DAY28;
  int count = 0;
  
  // Generate the clock
  always begin
    clk = 1'b1;
    #5;
    clk = 1'b0;
    #5;
  end
  
  // Generate stimulus
  initial begin
    reset <= 1'b1;
    req_i <= 1'b0;
    DAY28 = new();
    @(posedge clk);
    reset <= 1'b0;
    repeat (3) @(posedge clk);
    for (int txn=0; txn<10; txn++) begin
      @(posedge clk);
      // Write 10 transactions
      req_i       <= 1'b1;
      req_rnw_i   <= 0;
      // Randomize
      void'(DAY28.randomize());
      req_addr_i  <= DAY28.req_addr;
      req_wdata_i <= DAY28.req_wdata;
      // Update TB memory and addr list
      mem_tb[DAY28.req_addr] = DAY28.req_wdata;
      addr_list.push_back(DAY28.req_addr);
      // Fork a watchdog timeout thread while waiting for ready
      fork : waitAndTimeoutBlock
        begin
      	  // Wait for ready
      	  while (~req_ready_o) begin
            @(posedge clk);
      	  end
        end
        
        begin
          // Kill simulation once watchdog timeout hits
          count = 0;
          while (1) begin
            // Kill after 10 cycles
            if (count == 16) begin
              $fatal(1, "%t Watchdog Timeout! Ready not seen in 10 cycles", $time);
            end
            @(posedge clk);
            count++;
          end
        end
      join_any
      // Disable fork if we reach here
      // Can only reach here if ready is seen before timeout
      disable waitAndTimeoutBlock;
      req_i <= 1'b0;
    end
    // Wait for few cycles before reading
    repeat (5) @(posedge clk);
    for (int txn=0; txn<10; txn++) begin
      // Read 10 transactions
      req_i       <= 1'b1;
      req_rnw_i   <= 1;
      // Randomize the read address
      addr_list.shuffle();
      req_addr_i  <= addr_list[0];
      // Send random write data for reads too
      void'(DAY28.randomize());
      req_wdata_i <= DAY28.req_wdata;
      // Wait for ready
      while (~req_ready_o) begin
        @(posedge clk);
      end
      // Compare read data
      if (req_rdata_o !== mem_tb[addr_list[0]]) begin
        // Fatal error on mismatch
        $fatal(1, "Read data doesn't match! Expected: 0x%8x Got: 0x%8x", mem_tb[addr_list[0]], req_rdata_o);
      end
      req_i <= 1'b0;
      @(posedge clk);
    end
    // Test passes if we reach here
    $display("TEST PASSED!");
    $finish();
  end
  
  // Dump VCD
  initial begin
    $dumpfile("day36.vcd");
    $dumpvars(0, day36_tb);
  end
  
endmodule
