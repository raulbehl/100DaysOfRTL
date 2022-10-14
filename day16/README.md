# Day 16
Design and verify an APB master interface which generates an APB transfer using a command input:
| cmd_i | Comment |
|-------|---------|
| 2'b00 | No-operation |
| 2'b01 | APB Read from address 0xDEAD_CAFE |
| 2'b10 | Increment the previously read data and write to 0xDEAD_CAFE |
| 2'b11 | Invalid/Not possible |

## Interface Definition
- The `cmd_i` input remains stable until the APB transfer is complete
- The module should have the following interface:

```verilog
module day16 (
  input       wire        clk,
  input       wire        reset,

  input       wire[1:0]   cmd_i,

  output      wire        psel_o,
  output      wire        penable_o,
  output      wire[31:0]  paddr_o,
  output      wire        pwrite_o,
  output      wire[31:0]  pwdata_o,
  input       wire        pready_i,
  input       wire[31:0]  prdata_i
);
```
