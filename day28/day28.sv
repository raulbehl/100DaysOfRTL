class day28;
  
  rand bit[15:0] req_addr;
  rand bit[7:0]  req_wdata;
  
endclass

module day28_tb ();
  
  logic        clk;
  logic        reset;
  logic        req_i;
  logic        req_rnw_i;
  logic[15:0]  req_addr_i;
  logic[7:0]   req_wdata_i;
  logic        req_ready_o;
  logic[7:0]   req_rdata_o;
  
  day28 DAY28;

  // Decalare memory as an associative array
  byte mem_tb[bit[15:0]];
  
  bit [15:0] addr_list[$];
  
  // Instatiate the RTL
  day17 DAY17 (.*);
  
  
  // Generate the clock
  always begin
    clk = 1'b1;
    #5;
    clk = 1'b0;
    #5;
  end
  
  // Generate stimulus
  initial begin
    DAY28 = new();
    reset <= 1'b1;
    req_i <= 1'b0;
    @(posedge clk);
    reset <= 1'b0;
    @(posedge clk);
    for (int txn=0; txn<10; txn++) begin
      @(posedge clk);
      // Write 10 transactions
      req_i       <= 1'b1;
      req_rnw_i   <= 0;
      void'(DAY28.randomize());
      req_addr_i  <= DAY28.req_addr;
      req_wdata_i <= DAY28.req_wdata;
      // Update TB memory
      mem_tb[DAY28.req_addr] = DAY28.req_wdata;
      addr_list.push_back(DAY28.req_addr);
      // Wait for ready
      while (~req_ready_o) begin
        @(posedge clk);
      end
      req_i <= 1'b0;
    end
    repeat(3) @(posedge clk);
    for (int txn=0; txn<10; txn++) begin
      // Read 10 transactions
      req_i       <= 1'b1;
      req_rnw_i   <= 1;
      addr_list.shuffle();
      void'(DAY28.randomize());
      req_addr_i  <= addr_list[0];
      req_wdata_i <= DAY28.req_wdata;
      // Wait for ready
      while (~req_ready_o) begin
        @(posedge clk);
      end
      // Check rdata
      if (req_rdata_o !== mem_tb[addr_list[0]]) begin
        $fatal(1, "Read data doesn't match. Expected: 0x%8x Got: 0x%8x", mem_tb[addr_list[0]], req_rdata_o);
      end
      req_i <= 1'b0;
      @(posedge clk);
    end
    $display("TEST PASSED");
    $finish();
  end
  
  // Dump VCD
  initial begin
    $dumpfile("day28.vcd");
    $dumpvars(0, day28_tb);
  end
  
endmodule
