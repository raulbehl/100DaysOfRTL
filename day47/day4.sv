// A simple ALU

`include "prim_assert.sv"
module day4 (
  input     logic [7:0]   a_i,
  input     logic [7:0]   b_i,
  input     logic [2:0]   op_i,

  output    logic [7:0]   alu_o
);

  // Enum for ALU op
  localparam  OP_ADD = 3'b000;
  localparam  OP_SUB = 3'b001;
  localparam  OP_SLL = 3'b010;
  localparam  OP_LSR = 3'b011;
  localparam  OP_AND = 3'b100;
  localparam  OP_OR  = 3'b101;
  localparam  OP_XOR = 3'b110;
  localparam  OP_EQL = 3'b111;

  logic carry;

  always_comb begin
    alu_o = '0;
    carry = 1'b0;
    case (op_i)
     3'b000:  {carry, alu_o}= {1'b0, a_i} + {1'b0, b_i};
     3'b001:  alu_o = a_i - b_i;
     3'b010:  alu_o = a_i[7:0] << b_i[2:0];
     3'b011:  alu_o = a_i[7:0] >> b_i[2:0];
     3'b100:  alu_o = a_i[7:0] & b_i[7:0];
     3'b101:  alu_o = a_i | b_i;
     3'b110:  alu_o = a_i ^ b_i;
     3'b111:  alu_o = {7'h0, a_i == b_i};
    endcase
  end

  `ASSERT(op_add, `IMPLIES((op_i == 3'b000), (alu_o == (a_i + b_i))))
  `ASSERT(op_sub, `IMPLIES((op_i == 3'b001), (alu_o == (a_i - b_i))))
  `ASSERT(op_sll, `IMPLIES((op_i == 3'b010), (alu_o == (a_i<<b_i[2:0]))))
  `ASSERT(op_lsr, `IMPLIES((op_i == 3'b011), (alu_o == (a_i>>b_i[2:0]))))
  `ASSERT(op_and, `IMPLIES((op_i == 3'b100), (alu_o == (a_i&b_i))))
  `ASSERT(op_or,  `IMPLIES((op_i == 3'b101), (alu_o == (a_i|b_i))))
  `ASSERT(op_xor, `IMPLIES((op_i == 3'b110), (alu_o == (a_i^b_i))))
  `ASSERT(op_eql, `IMPLIES((op_i == 3'b111), (alu_o == (a_i==b_i))))

endmodule
