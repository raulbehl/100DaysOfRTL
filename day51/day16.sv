// APB Master

// TB should drive a cmd_i input decoded as:
//  - 2'b00 - No-op
//  - 2'b01 - Read from address 0xDEAD_CAFE
//  - 2'b10 - Increment the previously read data and store it to 0xDEAD_CAFE

`include "prim_assert.sv"

module day16 (
  input       wire        clk,
  input       wire        reset,

  input       wire[1:0]   cmd_i,

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

  always_ff @(posedge clk or posedge reset)
    if (reset)
      state_q <= ST_IDLE;
    else
      state_q <= nxt_state;

  always_comb begin
    nxt_state = state_q;
    case (state_q)
      ST_IDLE   : if (|cmd_i) nxt_state = ST_SETUP; else nxt_state = ST_IDLE;
      ST_SETUP  : nxt_state = ST_ACCESS;
      ST_ACCESS : begin
        if (pready_i) nxt_state = ST_IDLE;
      end
      default   : nxt_state = state_q;
    endcase
  end

  assign psel_o     = (state_q == ST_SETUP) | (state_q == ST_ACCESS);
  assign penable_o  = (state_q == ST_ACCESS);
  assign pwrite_o   = cmd_i[1];
  assign paddr_o    = 32'hDEAD_CAFE;
  assign pwdata_o   = rdata_q + 32'h1;

  // Capture the read data to store it for the next write
  always_ff @(posedge clk or posedge reset)
    if (reset)
      rdata_q <= 32'h0;
    else if (penable_o && pready_i)
      rdata_q <= prdata_i;

`ifdef FORMAL

  // Assume reset is high for the first cycle
  logic rst_for_cycle = 1'b0;

  always_ff @(posedge clk) begin
    rst_for_cycle <= 1'b1;

    assume (rst_for_cycle ^ reset);
  end

  // Assume cmd_i remains stable until pready is seen
  `ASSUME(cmd_stable, `IMPLIES(~pready_i | ~penable_o, $stable(cmd_i)))
  // Assume cmd_i is a valid value
  `ASSUME(cmd_valid, `IMPLIES(~pready_i | ~penable_o, (cmd_i != 2'b11)))
  // Assert cmd_i is behaving correctly
  //  - 2'b00 - No-op
  //  - 2'b01 - Read from address 0xDEAD_CAFE
  //  - 2'b10 - Increment the previously read data and store it to 0xDEAD_CAFE
  `ASSERT(cmd_chk0, `IMPLIES((cmd_i == 2'b10) & penable_o & ~pready_i, pwrite_o))
  `ASSERT(cmd_chk1, `IMPLIES((cmd_i == 2'b01) & penable_o & ~pready_i, ~pwrite_o))

  logic asrt_psel_rose;

  always_ff @(posedge clk)
    asrt_psel_rose <= $rose(psel_o);

  // Assert that penable is asserted one cycle after psel
  `ASSERT(penable_chk, `IMPLIES($rose(penable_o), (asrt_psel_rose)))

  // Check psel, penable, pwrite, pwdata and paddr are stable until pready is seen
  `ASSERT(psel_stable, `IMPLIES(penable_o & ~pready_i, $stable(psel_o)))
  `ASSERT(pwrite_stable, `IMPLIES(penable_o & ~pready_i, $stable(pwrite_o)))
  `ASSERT(pwdata_stable, `IMPLIES(penable_o & ~pready_i, $stable(pwdata_o)))
  `ASSERT(paddr_stable, `IMPLIES(penable_o & ~pready_i, $stable(paddr_o)))

`endif

endmodule
