# Day 6
Design and verify a simple shift register

## Interface Definition
The module should have the following interface:

```verilog
input     wire        clk,
input     wire        reset,
input     wire        x_i,  -> Serial input

output    wire[3:0]   sr_o  -> Shift register output
```
