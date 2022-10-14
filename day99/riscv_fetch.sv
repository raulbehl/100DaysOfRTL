// APB Master for the instruction fetch unit
module riscv_fetch (
  input       wire        clk,
  input       wire        reset,
  
  input 	  wire		  instr_done_i,

  // ------------------------------------------------------------
  // APB Interface to memory
  // ------------------------------------------------------------
  output      wire        psel_o,
  output      wire        penable_o,
  output      wire[31:0]  paddr_o,
  output      wire        pwrite_o,
  output      wire[31:0]  pwdata_o,
  input       wire        pready_i,
  input       wire[31:0]  prdata_i,
  // ------------------------------------------------------------
  // Instruction output
  // ------------------------------------------------------------
  output	  logic		  if_dec_valid_o,
  output	  logic[31:0] if_dec_instr_o,
  input		  wire[31:0]  ex_if_pc_i
);

  // Enum for the APB state
  typedef enum logic[1:0] {ST_IDLE = 2'b00, ST_SETUP = 2'b01, ST_ACCESS = 2'b10} apb_state_t;

  apb_state_t 	nxt_state;
  apb_state_t 	state_q;
  logic [31:0] 	if_pc_q;
  logic 		nxt_dec_valid;

  always_ff @(posedge clk or posedge reset)
    if (reset)
      state_q <= ST_IDLE;
    else
      state_q <= nxt_state;

  always_comb begin
    nxt_state = state_q;
    case (state_q)
      // Memory responses may not be single cycle. Wait for the
      // memory request to complete before requesting the next
      // instruction
      ST_IDLE   : nxt_state = instr_done_i ? ST_SETUP : ST_IDLE;
      ST_SETUP  : nxt_state = ST_ACCESS;
      ST_ACCESS : begin
        if (pready_i) nxt_state = ST_IDLE;
      end
    endcase
  end

  assign psel_o     = (state_q == ST_SETUP) | (state_q == ST_ACCESS);
  assign penable_o  = (state_q == ST_ACCESS);
  assign pwrite_o   = 1'b0; // No writes to IMEM
  assign paddr_o    = if_pc_q; // Current instruction counter
  assign pwdata_o   = 32'h0;

  // Start from 0x8000_0000 on reset
  always_ff @(posedge clk or posedge reset)
    if (reset)
      if_pc_q <= 32'h8000_0000;
    else
      if_pc_q <= ex_if_pc_i;
  
  // Capture the read data as the current instruction opcode
  always_ff @(posedge clk or posedge reset)
    if (reset) begin
      if_dec_instr_o <= 32'h0;
    end else if (penable_o && pready_i) begin
      if_dec_instr_o <= prdata_i;
    end
  
    always_ff @(posedge clk or posedge reset)
    if (reset) begin
      if_dec_valid_o <= 1'b0;
    end else if ((penable_o && pready_i) | if_dec_valid_o) begin
      if_dec_valid_o <= nxt_dec_valid;
    end
  
  // Set valid on:
  //  - Valid APB transfer and clear it next cycle if no valid transfer
  //    and if the flag was set
  assign nxt_dec_valid = (penable_o && pready_i); 
  
endmodule