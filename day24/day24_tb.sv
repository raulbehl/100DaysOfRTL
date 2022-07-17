// Virtual Interface

class day24;
  
  virtual day23 vif;
  
  task run ();
    // Drive APB Slave via virtual intf
    vif.psel <= 1'b0;
    vif.penable <= 1'b0;
    
    $display("Starting stimulus now...");
    repeat(5) @(posedge vif.clk);
    
    forever begin
      vif.psel 		<= 1'b1; // APB Setup
      @(posedge vif.clk);
      vif.penable	<= 1'b1; // APB Access
      vif.paddr[9:0]<= 10'h3EC;
      vif.pwrite	<= $urandom_range(0, 10)%2;
      vif.pwdata	<= $urandom_range(0, 1023);
      // Wait for pready
      wait (vif.pready);
      @(posedge vif.clk);
      vif.psel <= 1'b0;
      vif.penable <= 1'b0;
      repeat (2) @(posedge vif.clk);
    end
  endtask
  
endclass

module day24_tb ();
  
  logic		clk;
  logic		reset;
  
  day24 DAY24;
  
  // Instantiate the interface
  day23 day23_if (
    .clk		(clk),
    .reset		(reset)
  );
  
    // Create object and pass interface handle to virtual interface
  initial begin
    DAY24 = new();
    DAY24.vif = day23_if;
    DAY24.run();
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
    $dumpfile("day24.vcd");
    $dumpvars(0, day24_tb);
  end

  
endmodule
