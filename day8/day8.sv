// Binary to one-hot

module day8#(
  parameter BIN_W       = 4,
  parameter ONE_HOT_W   = 16
)(
  input   wire[BIN_W-1:0]     bin_i,
  output  wire[ONE_HOT_W-1:0] one_hot_o
);

  assign one_hot_o = 1'b1<<bin_i;

endmodule
