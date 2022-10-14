# Day 9
Design and verify a parameterized binary to gray code converter

## Interface Definition
The module should have the following interface:

```verilog
module day9 #(
  parameter VEC_W = 4
)(
  input     wire[VEC_W-1:0] bin_i,
  output    wire[VEC_W-1:0] gray_o

);
```
