// A simple module to create tiranga using waveforms!
// Happy 75th Independence Day :) 

module day64 #(
  parameter MAX_CYCLES = 1000
)(
  input     wire      clk,
  input     wire      reset
);

  logic chakra0;
  logic chakra1;
  logic [31:0] cnt_q;

  // Model a counter for the chakra
  always_ff @(posedge clk or posedge reset)
    if (reset)
      cnt_q <= 32'h0;
    else
      cnt_q <= cnt_q + 32'h1;

  assign chakra0 = ((cnt_q >= ((MAX_CYCLES/2)-30)) & (cnt_q <= ((MAX_CYCLES/2)+30))) & clk;
  assign chakra1 = (((cnt_q >= ((MAX_CYCLES/2)-50)) & (cnt_q <= ((MAX_CYCLES/2)-30))) |
                    ((cnt_q >= ((MAX_CYCLES/2)+30)) & (cnt_q <= ((MAX_CYCLES/2)+50)))) & clk;

endmodule
