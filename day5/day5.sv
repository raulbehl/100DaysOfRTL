// Odd counter

module day5 (
  input     wire        clk,
  input     wire        reset,

  output    logic[7:0]  cnt_o
);


  logic [7:0] nxt_cnt;

  always_ff @(posedge clk or posedge reset)
    if (reset)
      cnt_o <= 8'h1;
    else
      cnt_o <= nxt_cnt;

  assign nxt_cnt = cnt_o + 8'h2;

endmodule
