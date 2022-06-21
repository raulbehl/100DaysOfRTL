// Binary to gray code

module day9 #(
  parameter VEC_W = 4
)(
  input     wire[VEC_W-1:0] bin_i,
  output    wire[VEC_W-1:0] gray_o

);

  assign gray_o[VEC_W-1] = bin_i[VEC_W-1];

  genvar i;
  for (i=VEC_W-2; i>=0; i=i-1)
    assign gray_o[i] = bin_i[i+1] ^ bin_i[i];

endmodule
