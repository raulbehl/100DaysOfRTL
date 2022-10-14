// APB Master for the data memory unit
module riscv_dmem (
  input       wire        clk,
  input       wire        reset,
  
  input		  wire		  ex_dmem_valid_i, // Mem operation is valid
  input		  wire[31:0]  ex_dmem_addr_i,
  input		  wire[31:0]  ex_dmem_wdata_i,
  input	      wire	  	  ex_dmem_wnr_i, // 1 - write, 0 - read

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
  // Data output
  // ------------------------------------------------------------
  output	  logic[31:0] dmem_data_o,
  output 	  logic		  dmem_done_o
);

  // Enum for the APB state
  typedef enum logic[1:0] {ST_IDLE = 2'b00, ST_SETUP = 2'b01, ST_ACCESS = 2'b10} apb_state_t;

  apb_state_t 	nxt_state;
  apb_state_t 	state_q;
  logic [31:0] 	if_pc_q;

  always_ff @(posedge clk or posedge reset)
    if (reset)
      state_q <= ST_IDLE;
    else
      state_q <= nxt_state;

  always_comb begin
    nxt_state = state_q;
    case (state_q)
      ST_IDLE   : nxt_state = ex_dmem_valid_i ? ST_SETUP : ST_IDLE;
      ST_SETUP  : nxt_state = ST_ACCESS;
      ST_ACCESS : begin
        if (pready_i) nxt_state = ST_IDLE;
      end
    endcase
  end

  assign psel_o     = (state_q == ST_SETUP) | (state_q == ST_ACCESS);
  assign penable_o  = (state_q == ST_ACCESS);
  assign pwrite_o   = ex_dmem_wnr_i;
  assign paddr_o    = ex_dmem_addr_i; // Memory address
  assign pwdata_o   = ex_dmem_wdata_i;
  
  assign dmem_done_o = penable_o && pready_i;
  assign dmem_data_o = prdata_i;
  
endmodule