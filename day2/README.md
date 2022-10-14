# Day 2
Design and verify various flavours of a D flip-flop

## Interface Definition
The module should have the following interface:

```verilog
input     logic      clk,
input     logic      reset,

input     logic      d_i,         -> D input to the flop

output    logic      q_norst_o,   -> Q output from non-resettable flop
output    logic      q_syncrst_o, -> Q output from flop using synchronous reset
output    logic      q_asyncrst_o -> Q output from flop using asynchrnoous reset
```
