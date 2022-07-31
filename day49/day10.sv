// Counter with a load
`include "prim_assert.sv"
module day10 (
  input     wire          clk,
  input     wire          reset,
  input     wire          load_i,
  input     wire[3:0]     load_val_i,

  output    wire[3:0]     count_o
);

  logic[3:0] load_ff;

  // Store the load value whenever load_i is seen
  always_ff @(posedge clk or posedge reset)
    if (reset)
      load_ff <= 4'h0;
    else if (load_i)
      load_ff <= load_val_i;

  // Implement the counter
  // - Resets to 0
  // - Increments by 1 every cycle
  // - Takes the load value if load_i is seen
  // - Starts back from the load value after overflow
  logic[3:0] count_ff;
  logic[3:0] nxt_count;

  always_ff @(posedge clk or posedge reset)
    if (reset)
      count_ff <= 4'h0;
    else
      count_ff <= nxt_count;

  assign nxt_count = load_i ? load_val_i :
                              (count_ff == 4'hF) ? load_ff :
                              count_ff + 4'h1;

  assign count_o = count_ff;

`ifdef FORMAL

  // Assume reset for a cycle
  logic rst_for_a_cycle = 1'b0;

  always_ff @(posedge clk) begin
    rst_for_a_cycle <= 1'b1;

    assume (reset ^ rst_for_a_cycle);
  end

  // Assume load_i is low in reset
  `ASSUME_ZERO_IN_RESET(load_i)

  logic[3:0] load_val_latch;

  // Latch the load value whenever load_i is asserted
  always_ff @(posedge clk)
    if (reset)
      load_val_latch <= 4'h0;
    else if (load_i)
      load_val_latch <= load_val_i;


  // Check the counter behaviour
  // Should reflect load_val_i whenever load_i is asserted
  `ASSERT(load_val_chk, `IMPLIES($fell(load_i), $past(load_val_i) == count_o))

  // Should restart from load value once it reaches 0xF
  `ASSERT(reload_val_chk, `IMPLIES($past(count_o == 4'hF), (count_o == load_val_latch)))

  // Should increment if not 4'hF/load_i/reset in the last cycle
  `ASSERT(incr_val_chk, `IMPLIES($past(count_o != 4'hF) & ~$past(reset) & ~$past(load_i),
                                (($past(count_o)+4'h1) == count_o)))

`endif

endmodule
