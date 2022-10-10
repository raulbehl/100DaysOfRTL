# Day 19
Design and verify a parameterized synchronous fifo. Both the depth and data width should be parameterized

## Interface Definition
The module should have the following interface:

```verilog
module day19 #(
  parameter DEPTH   = 4,
  parameter DATA_W  = 1
)(
  input         wire              clk,
  input         wire              reset,

  input         wire              push_i,
  input         wire[DATA_W-1:0]  push_data_i,

  input         wire              pop_i,
  output        wire[DATA_W-1:0]  pop_data_o,

  output        wire              full_o,
  output        wire              empty_o
);
```
