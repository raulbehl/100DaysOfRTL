# Day 13
Design a 2:1 mux using the following language constructs:
| Construct |
|----------|
|Ternary Operator|
|Case statement|
|If else block|
|Combinatorial For loop|
|And-or tree|

## Interface Definition
The module should have the following interface:

```verilog
input     wire[3:0] a_i,
input     wire[3:0] sel_i,

// Output using ternary operator
output    wire     y_ter_o,
// Output using case
output    logic     y_case_o,
// Ouput using if-else
output    logic     y_ifelse_o,
// Output using for loop
output    logic     y_loop_o,
// Output using and-or tree
output    logic     y_aor_o
```
