# Day 17
Design and verify a valid/ready based memory interface slave. The interface should be able to generate
the ready output after a random delay. Memory should be `16x32` bits wide.

## Interface Definition
- Valid/ready protocol must be honoured
- The module should have the following interface:

```verilog
module day17 (
  input       wire        clk,
  input       wire        reset,

  input       wire        req_i,        -> Valid request input remains asserted until ready is seen
  input       wire        req_rnw_i,    -> Read-not-write (1-read, 0-write)
  input       wire[3:0]   req_addr_i,   -> 4-bit Memory address
  input       wire[31:0]  req_wdata_i,  -> 32-bit write data
  output      wire        req_ready_o,  -> Ready output when request accepted
  output      wire[31:0]  req_rdata_o   -> Read data from memory
);

  // Memory array
  logic [15:0][31:0] mem;
```
