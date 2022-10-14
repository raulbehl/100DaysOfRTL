// APB Master
module apb_master (
  input       wire        clk,
  input       wire        reset,

  output      wire        psel_o,
  output      wire        penable_o,
  output      wire[31:0]  paddr_o,
  output      wire        pwrite_o,
  output      wire[31:0]  pwdata_o,
  input       wire        pready_i,
  input       wire[31:0]  prdata_i
);

  // Enum for the APB state
  typedef enum logic[1:0] {ST_IDLE = 2'b00, ST_SETUP = 2'b01, ST_ACCESS = 2'b10} apb_state_t;

  apb_state_t nxt_state;
  apb_state_t state_q;

  logic[31:0] rdata_q;
  
  // Load a counter with LFSR value every time a pready is seen
  // Wait for the counter to be 0 before starting a new APB request
  // This removed the need of the `cmd_i` signal for starting the request
  logic [3:0] count_ff;
  logic [3:0] nxt_count;
  logic [3:0] lfsr_val;
  logic [3:0] count;

  always_ff @(posedge clk or posedge reset)
    if (reset)
      count_ff <= 4'hF;
    else
      count_ff <= nxt_count;

  assign nxt_count = pready_i ? lfsr_val:
                                count_ff - 4'h1;

  assign count = count_ff;

  // Generate a random load value
  day7 DAY7 (
    .clk            (clk),
    .reset          (reset),
    .lfsr_o         (lfsr_val)
  );

  always_ff @(posedge clk or posedge reset)
    if (reset)
      state_q <= ST_IDLE;
    else
      state_q <= nxt_state;

  always_comb begin
    nxt_state = state_q;
    case (state_q)
      ST_IDLE   : if (count_ff == 4'h0) nxt_state = ST_SETUP; else nxt_state = ST_IDLE;
      ST_SETUP  : nxt_state = ST_ACCESS;
      ST_ACCESS : begin
        if (pready_i) nxt_state = ST_IDLE;
      end
    endcase
  end
  
  logic ping_pong;
  
  always_ff @(posedge clk or posedge reset)
    if (reset)
      ping_pong <= 1'b1;
    else if (state_q == ST_IDLE)
      ping_pong <= ~ping_pong;

  assign psel_o     = (state_q == ST_SETUP) | (state_q == ST_ACCESS);
  assign penable_o  = (state_q == ST_ACCESS);
  assign pwrite_o   = ping_pong;
  assign paddr_o    = 32'hDEAD_CAFE;
  assign pwdata_o   = rdata_q + 32'h1;

  // Capture the read data to store it for the next write
  always_ff @(posedge clk or posedge reset)
    if (reset)
      rdata_q <= 32'h0;
    else if (penable_o && pready_i)
      rdata_q <= prdata_i;

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