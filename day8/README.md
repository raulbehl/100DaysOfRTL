# Day 8
Design and verify a parameterized binary to one-hot converter

## Interface Definition
The module should have the following interface:

```verilog
module day8#(
  parameter BIN_W       = 4,
  parameter ONE_HOT_W   = 16
)(
  input   wire[BIN_W-1:0]     bin_i,    -> Binary input vector
  output  wire[ONE_HOT_W-1:0] one_hot_o -> One-hot output
);
```
