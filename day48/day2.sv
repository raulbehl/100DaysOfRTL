// Different DFF

`include "prim_assert.sv"

module day2 (
  input     logic      clk,
  input     logic      reset,

  input     logic      d_i,

  output    logic      q_norst_o,
  output    logic      q_syncrst_o,
  output    logic      q_asyncrst_o
);

  // No reset
  always_ff @(posedge clk)
    q_norst_o <= d_i;

  // Sync reset
  always_ff @(posedge clk)
    if (reset)
      q_syncrst_o <= 1'b0;
    else
      q_syncrst_o <= d_i;

  // Async reset
  always_ff @(posedge clk or posedge reset)
    if (reset)
      q_asyncrst_o <= 1'b0;
    else
      q_asyncrst_o <= d_i;

`ifdef FORMAL

  // Assume reset is high for a cycle initially
  logic rst_for_cycle = 1'b0;

  always_ff @(posedge clk) begin
    rst_for_cycle <= 1'b1;

    assume(reset ^ rst_for_cycle);
  end

  // Reset check assertions
  // Reset value check for syncreset. Should happen on the next cycle for sync reset
  // `ASSERT masks the check when in reset hence use `ASSERT_NODIS
  `ASSERT_NODIS(rst_syncrst, `IMPLIES($fell(reset), q_syncrst_o == 1'b0))

  // Reset value check for asyncreset. Should happen on the same cycle as reset assertion
  // `ASSERT masks the check when in reset hence use `ASSERT_NODIS
  `ASSERT_NODIS(rst_asyncrst, `IMPLIES(reset, q_asyncrst_o == 1'b0))

  // Data check
  // Assume d_i is zero while in reset
  `ASSUME_ZERO_IN_RESET(d_i)

  // Data checks for all the three outputs
  // Check on every cycle
  `ASSERT(data_norst,     `IMPLIES(1'b1, $past(d_i) == q_norst_o))
  `ASSERT(data_syncrst,   `IMPLIES(1'b1, $past(d_i) == q_syncrst_o))
  `ASSERT(data_asyncrst,  `IMPLIES(1'b1, $past(d_i) == q_asyncrst_o))

`endif

endmodule
