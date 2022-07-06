// Day23 Interface

interface day23 (
  input		wire		clk,
  input		wire		reset
);
  
  logic			psel;
  logic			penable;
  logic[31:0]	paddr;
  logic			pwrite;
  logic[31:0]	pwdata;
  logic[31:0]	prdata;
  logic			pready;
  
  modport apb_master (
    input		psel,
    input		penable,
    input		paddr,
    input		pwrite,
    input		pwdata,
    output		prdata,
    output		pready
  );
  
  modport apb_slave (
    output		psel,
    output		penable,
    output		paddr,
    output		pwrite,
    output		pwdata,
    input 		prdata,
    input		pready
  );
  
endinterface

// APB Slave RTL
module day18 (
  input         wire        clk,
  input         wire        reset,

  day23.apb_slave			apb_if
);

  // Valid APB request
  logic apb_req;

  assign apb_req = apb_if.psel & apb_if.penable;

  // Instantiate the memory interface
  day17 DAY17 (
    .clk            (clk),
    .reset          (reset),
    .req_i          (apb_req),
    .req_rnw_i      (~apb_if.pwrite),
    .req_addr_i     (apb_if.paddr[9:0]),
    .req_wdata_i    (apb_if.pwdata),
    .req_ready_o    (apb_if.pready),
    .req_rdata_o    (apb_if.prdata)
  );

endmodule

// A memory interface

module day17 (
  input       wire        clk,
  input       wire        reset,

  input       wire        req_i,
  input       wire        req_rnw_i,    // 1 - read, 0 - write
  input       wire[9:0]   req_addr_i,
  input       wire[31:0]  req_wdata_i,
  output      wire        req_ready_o,
  output      wire[31:0]  req_rdata_o
);

  // Memory array
  logic [1023:0][31:0] mem ;

  logic mem_rd;
  logic mem_wr;

  logic req_rising_edge;

  logic [3:0] lfsr_val;
  logic [3:0] count;

  assign mem_rd = req_i &  req_rnw_i;
  assign mem_wr = req_i & ~req_rnw_i;

  // Detect a rising edge on the req_i
  day3 DAY3 (
    .clk            (clk),
    .reset          (reset),
    .a_i            (req_i),
    .rising_edge_o  (req_rising_edge),
    .falling_edge_o (/* Not needed */)
  );

  // Load a counter with random value on the rising edge
  logic[3:0] count_ff;
  logic[3:0] nxt_count;

  always_ff @(posedge clk or posedge reset)
    if (reset)
      count_ff <= 4'h0;
    else
      count_ff <= nxt_count;

  assign nxt_count = req_rising_edge ? lfsr_val:
                                       count_ff + 4'h1;

  assign count = count_ff;

  // Generate a random load value
  day7 DAY7 (
    .clk            (clk),
    .reset          (reset),
    .lfsr_o         (lfsr_val)
  );

  // Write into the mem when the counter is 0
  always_ff @(posedge clk)
    if (mem_wr & ~|count)
      mem[req_addr_i] <= req_wdata_i;

  // Read directly
  assign req_rdata_o = mem[req_addr_i] & {32{mem_rd}};

  // Assert ready only when counter is at 0
  // This will add random delays on when memory gives the ready
  assign req_ready_o = ~|count;

endmodule

// An edge detector


module day3 (
  input     wire    clk,
  input     wire    reset,

  input     wire    a_i,

  output    wire    rising_edge_o,
  output    wire    falling_edge_o
);

  logic a_ff;

  always_ff @(posedge clk or posedge reset)
    if (reset)
      a_ff <= 1'b0;
    else
      a_ff <= a_i;

  // Rising edge when delayed signal is 0 but current is 1
  assign rising_edge_o = ~a_ff & a_i;

  // Falling edge when delayed signal is 1 but current is 0
  assign falling_edge_o = a_ff & ~a_i;

endmodule

// LFSR
module day7 (
  input     wire      clk,
  input     wire      reset,

  output    wire[3:0] lfsr_o
);

  logic [3:0] lfsr_ff;
  logic [3:0] nxt_lfsr;

  always_ff @(posedge clk or posedge reset)
    if (reset)
      lfsr_ff <= 4'hE;
    else
      lfsr_ff <= nxt_lfsr;

  assign nxt_lfsr = {lfsr_ff[2:0], lfsr_ff[1] ^ lfsr_ff[3]};

  assign lfsr_o = lfsr_ff;

endmodule
