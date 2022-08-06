// APB Slave
`include "prim_assert.sv"

module day18 (
  input         wire        clk,
  input         wire        reset,

  input         wire        psel_i,
  input         wire        penable_i,
  input         wire[9:0]   paddr_i,
  input         wire        pwrite_i,
  input         wire[31:0]  pwdata_i,
  output        wire[31:0]  prdata_o,
  output        wire        pready_o
);

  // Valid APB request
  logic apb_req;

  assign apb_req = psel_i & penable_i;

  // Instantiate the memory interface
  day17 DAY17 (
    .clk            (clk),
    .reset          (reset),
    .req_i          (apb_req),
    .req_rnw_i      (~pwrite_i),
    .req_addr_i     (paddr_i),
    .req_wdata_i    (pwdata_i),
    .req_ready_o    (pready_o),
    .req_rdata_o    (prdata_o)
  );

`ifdef FORMAL

  // Assume reset is high for the first cycle
  logic rst_for_cycle = 1'b0;

  always_ff @(posedge clk) begin
    rst_for_cycle <= 1'b1;

    assume (rst_for_cycle ^ reset);
  end

  logic asrt_psel_rose;

  always_ff @(posedge clk)
    asrt_psel_rose <= $rose(psel_i);

  // Assume psel and penable are deasserted in reset
  `ASSUME_ZERO_IN_RESET(psel_i)
  `ASSUME_ZERO_IN_RESET(penable_i)

  // Assume that penable is asserted one cycle after psel
  `ASSUME(penable_chk, `IMPLIES($rose(penable_i), (asrt_psel_rose)))

  // Assume no back-to-back requests
  `ASSUME(psel_b2b, `IMPLIES($past(psel_i & penable_i & pready_o), ~psel_i))
  `ASSUME(penable_b2b, `IMPLIES($past(psel_i & penable_i & pready_o), ~penable_i))

  // Psel stable
  `ASSUME(psel_stable, `IMPLIES($past(psel_i & ~penable_i), $stable(psel_i))) // Setup
  `ASSUME(psel_stable2, `IMPLIES($past(psel_i & penable_i & ~pready_o), $stable(psel_i))) // Access

  // Penable stable
  `ASSUME(penable_stable, `IMPLIES($past(psel_i & penable_i & ~pready_i), $stable(penable_i)))

  // Assume psel, penable, pwrite, pwdata and paddr are stable until pready is seen
  `ASSUME(pwrite_stable, `IMPLIES($past(psel_i & penable_i & ~pready_o), $stable(pwrite_i)))
  `ASSUME(pwdata_stable, `IMPLIES($past(psel_i & penable_i & ~pready_o), $stable(pwdata_i)))
  `ASSUME(paddr_stable,  `IMPLIES($past(psel_i & penable_i & ~pready_o), $stable(paddr_i)))

  // Add a failing check to view stimulus
  `ASSERT(asrt_fail, `IMPLIES(psel_i & penable_i & pready_o, pwdata_i == 32'hdead_cafe)) 

`endif
endmodule
