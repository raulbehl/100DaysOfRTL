// Virtual Interface

class day25;
  
  virtual day23 vif;
  
  // Declare class member variables using rand keywork
  rand logic[31:0]	paddr;
  rand logic[31:0]	pwdata;
  rand logic		pwrite;
  
  // Queue to hold all the addresses
  logic[31:0] addrQ[$];
  
  task run ();
    // Drive APB Slave via virtual intf
    vif.psel <= 1'b0;
    vif.penable <= 1'b0;
    
    $display("Starting stimulus now...");
    repeat(5) @(posedge vif.clk);
    
    forever begin
      // Randomise paddr, pwdata and pwrite for every transaction
      void'(randomize(pwrite));
      void'(randomize(pwdata));
      void'(randomize(paddr));
      // First access should always be a write to avoid X-prop
      if (addrQ.size() == 0) begin
        pwrite = 1;
      end else begin
        // Use random address for a write but pick one from queue for a read
        addrQ.shuffle();
        if (~pwrite) begin
          paddr = addrQ[0];
        end
      end
      // Push paddr to the queue
      addrQ.push_back(paddr);
      vif.psel 		<= 1'b1; // APB Setup
      @(posedge vif.clk);
      vif.penable	<= 1'b1; // APB Access
      vif.paddr[9:0]<= paddr;
      vif.pwrite	<= pwrite;
      vif.pwdata	<= pwdata;
      // Wait for pready
      wait (vif.pready);
      @(posedge vif.clk);
      vif.psel <= 1'b0;
      vif.penable <= 1'b0;
      repeat (2) @(posedge vif.clk);
    end
  endtask
  
endclass

module day25_tb ();
  
  logic		clk;
  logic		reset;
  
  day25 DAY25;
  
  // Instantiate the interface
  day23 day23_if (
    .clk		(clk),
    .reset		(reset)
  );
  
    // Create object and pass interface handle to virtual interface
  initial begin
    DAY25 = new();
    DAY25.vif = day23_if;
    DAY25.run();
  end
  
  // Instantiate APB slave RTL
  day18 apb_slave (
    .clk		(clk),
    .reset		(reset),
    .apb_if		(day23_if.apb_slave)
  );
  
  // Generate clock
  always begin
    clk = 1'b0;
    #5;
    clk = 1'b1;
    #5;
  end
  
  // Generate reset
  initial begin
    reset <= 1'b1;
    repeat (3) @(posedge clk);
    reset <= 1'b0;
    repeat (150) @(posedge clk);
    $finish();
  end

  // Dump VCD
  initial begin
    $dumpfile("day25.vcd");
    $dumpvars(0, day25_tb);
  end

  
endmodule
