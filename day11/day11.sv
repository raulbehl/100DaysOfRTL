// Parallel to serial with valid and empty

module day11 (
  input     wire      clk,
  input     wire      reset,

  output    wire      empty_o,
  input     wire[3:0] parallel_i,
  
  output    wire      serial_o,
  output    wire      valid_o
);

  // Shift register for the conversion
  logic [3:0] shift_ff;
  logic [3:0] nxt_shift;

  always_ff @(posedge clk or posedge reset)
    if (reset)
      shift_ff <= 4'h0;
    else
      shift_ff <= nxt_shift;

  // Take the parallel input when empty
  // Otherwise give the data out serially
  assign nxt_shift = empty_o ? parallel_i :
                               {1'b0, shift_ff[3:1]};

  assign serial_o = shift_ff[0];

  // Maintain a counter to drive valid and empty
  logic [2:0] count_ff;
  logic [2:0] nxt_count;

  always_ff @(posedge clk or posedge reset)
    if (reset)
      count_ff <= 3'h0;
    else
      count_ff <= nxt_count;

  // Count goes to zero when it reaches 4 (as all data given out)
  assign nxt_count = (count_ff == 3'h4) ? 3'h0 :
                                          count_ff + 3'h1;

  // Valid when count greater than 0
  assign valid_o = |count_ff;

  // Empty when count_ff == 0
  assign empty_o = (count_ff == 3'h0);

endmodule
