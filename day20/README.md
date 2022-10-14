# Day 20
Design and verify a read/write system described below:
- Writes should have higher priority than reads
- Sytem should be able to buffer 16 read or write requests to avoid any loss
- System must use APB master/slave protocol to communicate to memory interface

```
                                   rd_valid_o
                                       ^
                                       |
|-----|    |------|    |------|     |------|
| ARB | -> | FIFO | -> | APBM | <-> | APBS | => rd_data_o
|-----|    |------|    |------|     |------|
```

_The idea behind this problem is to exercise how a complex system can be created by connecting various
small blocks together_

## Interface Definition
- The module should have the following interface:

```verilog
module day20 (
  input       wire        clk,
  input       wire        reset,

  input       wire        read_i,       - Sends a read request when asserted
  input       wire        write_i,      - Sends a write request when asserted

  output      wire        rd_valid_o,   - Should be asserted whenever read data is valid
  output      wire[31:0]  rd_data_o     - Read data
);
```
