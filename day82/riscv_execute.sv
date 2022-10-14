module riscv_execute (
  input		wire [31:0] opr_a_i,
  input		wire [31:0] opr_b_i,
  input		wire [3:0]	op_sel_i,
  output	wire [31:0]	ex_res_o
);
  
  logic [31:0] alu_res;
  logic signed [31:0] sign_opr_a;
  logic signed [31:0] sign_opr_b;
  
  assign sign_opr_a = opr_a_i;
  assign sign_opr_b = opr_b_i;
  
  // Supported Operations
  localparam OP_ADD = 4'b0000;
  localparam OP_SUB = 4'b0001;
  localparam OP_SLL = 4'b0010;
  localparam OP_LSR = 4'b0011;
  localparam OP_ASR = 4'b0100;
  localparam OP_OR	= 4'b0101;
  localparam OP_AND	= 4'b0110;
  localparam OP_XOR	= 4'b0111;
  localparam OP_EQL = 4'b1000;
  localparam OP_ULT = 4'b1001;
  localparam OP_UGT = 4'b1010;
  localparam OP_SLT = 4'b1011;
  localparam OP_SGT = 4'b1100;
  
  always_comb begin
    alu_res = 32'h0;
    case (op_sel_i)
      OP_ADD: alu_res = opr_a_i + opr_b_i;
      OP_SUB: alu_res = opr_a_i - opr_b_i;
      OP_SLL: alu_res = opr_a_i << opr_b_i[4:0];
      OP_LSR: alu_res = opr_a_i >> opr_b_i[4:0];
      OP_ASR: alu_res = sign_opr_a >>> opr_b_i[4:0];
      OP_OR:  alu_res = opr_a_i | opr_b_i;
      OP_AND: alu_res = opr_a_i & opr_b_i;
      OP_XOR: alu_res = opr_a_i ^ opr_b_i;
      OP_EQL: alu_res = {31'h0, opr_a_i == opr_b_i};
      OP_ULT: alu_res = {31'h0, opr_a_i < opr_b_i};
      OP_UGT: alu_res = {31'h0, opr_a_i >= opr_b_i};
      OP_SLT: alu_res = {31'h0, sign_opr_a < sign_opr_b};
      OP_SGT: alu_res = {31'h0, sign_opr_a >= sign_opr_b};
    endcase
  end
  
  assign ex_res_o = alu_res;
  
endmodule
