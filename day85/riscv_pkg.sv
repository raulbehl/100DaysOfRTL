`ifndef RISCV_PKG
`define RISCV_PKG

package riscv_pkg;
  
  // Supported ALU Operations
  typedef enum logic[3:0] {
   OP_ADD = 4'b0000,
   OP_SUB = 4'b0001,
   OP_SLL = 4'b0010,
   OP_LSR = 4'b0011,
   OP_ASR = 4'b0100,
   OP_OR  = 4'b0101,
   OP_AND = 4'b0110,
   OP_XOR = 4'b0111,
   OP_EQL = 4'b1000,
   OP_ULT = 4'b1001,
   OP_UGT = 4'b1010,
   OP_SLT = 4'b1011,
   OP_SGT = 4'b1100} alu_op_t;

  typedef enum logic [5:0] {
    // R-type defines
    ADD 	= 6'h0,
    AND 	= 6'h7,
    OR  	= 6'h6,
    SLL 	= 6'h1,
    SLT 	= 6'h2,
    SLTU	= 6'h3,
    SRA		= 6'hD,
    SRL		= 6'h5,
    SUB		= 6'h8,
    XOR		= 6'h4 } r_type_instr_t;

  typedef enum logic [5:0] {
    // I-type defines
    LB  	= 6'h0,
    LBU 	= 6'h4,
    LH  	= 6'h1,
    LHU 	= 6'h5,
    LW  	= 6'h2,
    ADDI	= 6'h10, // Formed with {opc[4], {1'b0, funct3}}
    ANDI	= 6'h1C,
    ORI 	= 6'h16,
    SLLI	= 6'h11,
    SRLI	= 6'h15,
    SLTI	= 6'h12,
    SLTIU	= 6'h13,
    //SRAI 	= 6'h15, // TODO: Update enum to avoid duplicates
  	XORI	= 6'h14,
  	JALR	= 6'h7
  } i_type_instr_t;
endpackage

`endif