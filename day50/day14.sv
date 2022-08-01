// Priority arbiter
// port[0] - highest priority

`include "prim_assert.sv"
module day14 #(
  parameter NUM_PORTS = 4
)(
    input       wire[NUM_PORTS-1:0] req_i,
    output      wire[NUM_PORTS-1:0] gnt_o   // One-hot grant signal
);
  // Port[0] has highest priority
  assign gnt_o[0] = req_i[0];

  genvar i;
  for (i=1; i<NUM_PORTS; i=i+1) begin
    assign gnt_o[i] = req_i[i] & ~(|gnt_o[i-1:0]);
  end

`ifdef FORMAL

  // Assume req_i is non-zero
  `ASSUME(req_nonzero, `IMPLIES(1'b1, (req_i != NUM_PORTS'(1'b0))))

  // Check grant is one-hot
  `ASSERT(gnt_onehot, `IS_ONE_HOT(gnt_o, NUM_PORTS))

  // Check arbiter operation
  `ASSERT(gnt_req0, `IMPLIES(req_i[0], (gnt_o == NUM_PORTS'(1'b1))))

  for (genvar i=1; i<NUM_PORTS; i=i+1) begin : g_gnt_req_assert
    // Grant on port[i] can only be asserted if request on port[i] is asserted
    // and no other lower port has the request asserted
    always_ff @(posedge clk) begin
      assert((req_i[i] & ~|req_i[i-1:0]) | (!(gnt_o[i])));
    end
  end

`endif

endmodule
