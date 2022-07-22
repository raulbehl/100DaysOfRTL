module day1 (
  input   wire [7:0]    a_i,
  input   wire [7:0]    b_i,
  input   wire          sel_i,
  output  wire [7:0]    y_o
);

  // Use the ternary operator to select either the input
  // a_i or b_i
  // y_o = a_i when sel_i = 1'b1
  // y+o = b_i when sel_i = 1'b0
  assign y_o = sel_i ? a_i : b_i;

endmodule