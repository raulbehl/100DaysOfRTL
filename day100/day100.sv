module day100 #(
  parameter MAX_CYCLES_PER_CHAR = 500
)(
  input     wire      clk,
  input     wire      reset,

  input     wire      start_i,
  input     wire[9:0] character_i
);

  localparam SPACE_CYCLES = (MAX_CYCLES_PER_CHAR/5);
  localparam MAX_VALID_CYCLES = MAX_CYCLES_PER_CHAR - (2*SPACE_CYCLES);
  localparam VERTICAL_WIDTH = SPACE_CYCLES - (SPACE_CYCLES/5);

  logic        a0;
  logic        a1;
  logic        a2;
  logic        a3;
  logic        b1;
  logic        b2;
  logic        b3;
  logic        plot_a0;
  logic        plot_a2;
  logic        plot_a3_a1;
  logic        plot_b2;
  logic        plot_b3_b1;
  logic [6:0]  block;
  logic [31:0] cnt_q;
  logic [31:0] nxt_cnt;
  logic        start_seen_q;

  always_ff @(posedge clk or posedge reset)
    if (reset)
      start_seen_q <= 1'b0;
    else if (start_i)
      start_seen_q <= 1'b1;

  assign {a3, a2, a1, a0,
              b3, b2, b1} = block;

  always_comb begin
    case (character_i)
      //Character A
      //                 a3,   a2,   a1,   a0,   b3,   b2,   b1
      10'd65: block = {1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1};
      //Character B
      //                 a3,   a2,   a1,   a0,   b3,   b2,   b1
      10'd66: block = {1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1};
      //Character C
      //                 a3,   a2,   a1,   a0,   b3,   b2,   b1
      10'd67: block = {1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0};
      //Character D
      //                 a3,   a2,   a1,   a0,   b3,   b2,   b1
      10'd68: block = {1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1};
      //Character E
      //                 a3,   a2,   a1,   a0,   b3,   b2,   b1
      10'd69: block = {1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0};
      //Character F
      //                 a3,   a2,   a1,   a0,   b3,   b2,   b1
      10'd70: block = {1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0};
      //Character G
      //                 a3,   a2,   a1,   a0,   b3,   b2,   b1
      10'd71: block = {1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1};
      //Character H
      //                 a3,   a2,   a1,   a0,   b3,   b2,   b1
      10'd72: block = {1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1};
      //Character I
      //                 a3,   a2,   a1,   a0,   b3,   b2,   b1
      10'd73: block = {1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0};
      //Character J
      //                 a3,   a2,   a1,   a0,   b3,   b2,   b1
      10'd74: block = {1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1};
      //Character K
      //                 a3,   a2,   a1,   a0,   b3,   b2,   b1
      10'd75: block = {1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 1'b1};
      //Character L
      //                 a3,   a2,   a1,   a0,   b3,   b2,   b1
      10'd76: block = {1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0};
      //Character M
      //                 a3,   a2,   a1,   a0,   b3,   b2,   b1
      10'd77: block = {1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 1'b1};
      //Character N
      //                 a3,   a2,   a1,   a0,   b3,   b2,   b1
      10'd78: block = {1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1};
      //Character O
      //                 a3,   a2,   a1,   a0,   b3,   b2,   b1
      10'd79: block = {1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1};
      //Character P
      //                 a3,   a2,   a1,   a0,   b3,   b2,   b1
      10'd80: block = {1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0};
      //Character Q
      //                 a3,   a2,   a1,   a0,   b3,   b2,   b1
      10'd81: block = {1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1};
      //Character R
      //                 a3,   a2,   a1,   a0,   b3,   b2,   b1
      10'd82: block = {1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0};
      //Character S
      //                 a3,   a2,   a1,   a0,   b3,   b2,   b1
      10'd83: block = {1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1};
      //Character T
      //                 a3,   a2,   a1,   a0,   b3,   b2,   b1
      10'd84: block = {1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0};
      //Character U
      //                 a3,   a2,   a1,   a0,   b3,   b2,   b1
      10'd85: block = {1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1};
      //Character V
      //                 a3,   a2,   a1,   a0,   b3,   b2,   b1
      10'd86: block = {1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0};
      //Character W
      //                 a3,   a2,   a1,   a0,   b3,   b2,   b1
      10'd87: block = {1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0};
      //Character X
      //                 a3,   a2,   a1,   a0,   b3,   b2,   b1
      10'd88: block = {1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1};
      //Character Y
      //                 a3,   a2,   a1,   a0,   b3,   b2,   b1
      10'd89: block = {1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1};
      //Character Z
      //                 a3,   a2,   a1,   a0,   b3,   b2,   b1
      10'd90: block = {1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0};
      //Character 0
      //                 a3,   a2,   a1,   a0,   b3,   b2,   b1
      10'd48: block = {1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1};
      //Character 1
      //                 a3,   a2,   a1,   a0,   b3,   b2,   b1
      10'd49: block = {1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1};
      //Character 2
      //                 a3,   a2,   a1,   a0,   b3,   b2,   b1
      10'd50: block = {1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0};
      //Character 3
      //                 a3,   a2,   a1,   a0,   b3,   b2,   b1
      10'd51: block = {1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1};
      //Character 4
      //                 a3,   a2,   a1,   a0,   b3,   b2,   b1
      10'd52: block = {1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1};
      //Character 5
      //                 a3,   a2,   a1,   a0,   b3,   b2,   b1
      10'd53: block = {1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1};
      //Character 6
      //                 a3,   a2,   a1,   a0,   b3,   b2,   b1
      10'd54: block = {1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1};
      //Character 7
      //                 a3,   a2,   a1,   a0,   b3,   b2,   b1
      10'd55: block = {1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1};
      //Character 8
      //                 a3,   a2,   a1,   a0,   b3,   b2,   b1
      10'd56: block = {1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1};
      //Character 9
      //                 a3,   a2,   a1,   a0,   b3,   b2,   b1
      10'd57: block = {1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1};
      default: block = '0;
    endcase
  end

  always_ff @(posedge clk or posedge reset)
    if (reset)
      cnt_q <= 32'h0;
    else if (start_seen_q)
      cnt_q <= nxt_cnt;

  assign nxt_cnt = (cnt_q == MAX_CYCLES_PER_CHAR) ? 32'h0 : cnt_q + 32'h1;

  assign plot_a0    = ((cnt_q >= VERTICAL_WIDTH) & (cnt_q < MAX_VALID_CYCLES)) & clk & a0;
  assign plot_a3_a1 = (((cnt_q >= 32'h0) & (cnt_q < VERTICAL_WIDTH)) & clk & a3) |
                      (((cnt_q >= MAX_VALID_CYCLES) & (cnt_q < (MAX_VALID_CYCLES + VERTICAL_WIDTH))) & clk & a1);
  assign plot_a2    = ((cnt_q >= VERTICAL_WIDTH) & (cnt_q < MAX_VALID_CYCLES)) & clk & a2;
  assign plot_b2    = ((cnt_q >= VERTICAL_WIDTH) & (cnt_q < MAX_VALID_CYCLES)) & clk & b2;
  assign plot_b3_b1 = (((cnt_q >= 32'h0) & (cnt_q < VERTICAL_WIDTH)) & clk & b3) |
                      (((cnt_q >= MAX_VALID_CYCLES) & (cnt_q < (MAX_VALID_CYCLES + VERTICAL_WIDTH))) & clk & b1);

endmodule
