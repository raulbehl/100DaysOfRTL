# Day 18
Design and verify a APB slave interface which utilises the memory interface designed on [day17](https://github.com/raulbehl/100DaysOfRTL/tree/main/day17)

## Interface Definition
- The module should have the following interface:

```verilog
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
```
