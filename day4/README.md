# Day 4
Design and verify a 8-bit ALU which supports the following encoded operations:
| Encoding | Operation | Comment |
|----------|-----------|---------|
|3'b000|ADD|-|
|3'b001|SUB|-|
|3'b010|SLL|Vector a should left shift using bits 2:0 of vector b|
|3'b011|LSR|Vector a should right shift using bits 2:0 of vector b|
|3'b100|AND|-|
|3'b101|OR |-|
|3'b110|XOR|-|
|3'b111|EQL|Output should be 1 when equal otherwise 0|

## Interface Definition
The module should have the following interface:

```verilog
input     logic [7:0]   a_i,  - First 8-bit input vector
input     logic [7:0]   b_i,  - Second 8-bit input vector
input     logic [2:0]   op_i, - Encoded operation

output    logic [7:0]   alu_o - ALU output
```
