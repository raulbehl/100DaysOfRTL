// Day23 Interface

interface day23 (
  input		wire		clk,
  input		wire		reset
);
  
  logic			psel;
  logic			penable;
  logic[31:0]	paddr;
  logic			pwrite;
  logic[31:0]	pwdata;
  logic[31:0]	prdata;
  logic			pready;
  
  modport apb_master (
    input		psel,
    input		penable,
    input		paddr,
    input		pwrite,
    input		pwdata,
    output		prdata,
    output		pready
  );
  
  modport apb_slave (
    output		psel,
    output		penable,
    output		paddr,
    output		pwrite,
    output		pwdata,
    input 		prdata,
    input		pready
  );
  
endinterface

module day16 (
  input       wire        clk,
  input       wire        reset,

  input       wire[1:0]   cmd_i,

  day23.apb_master        apb_if
);

  // Enum for the APB state
  typedef enum logic[1:0] {ST_IDLE = 2'b00, ST_SETUP = 2'b01, ST_ACCESS = 2'b10} apb_state_t;

  apb_state_t nxt_state;
  apb_state_t state_q;

  logic[31:0] rdata_q;

  always_ff @(posedge clk or posedge reset)
    if (reset)
      state_q <= ST_IDLE;
    else
      state_q <= nxt_state;

  always_comb begin
    nxt_state = state_q;
    case (state_q)
      ST_IDLE   : if (|cmd_i) nxt_state = ST_SETUP; else nxt_state = ST_IDLE;
      ST_SETUP  : nxt_state = ST_ACCESS;
      ST_ACCESS : begin
        if (apb_if.pready) nxt_state = ST_IDLE;
      end
    endcase
  end

  assign apb_if.psel     = (state_q == ST_SETUP) | (state_q == ST_ACCESS);
  assign apb_if.penable  = (state_q == ST_ACCESS);
  assign apb_if.pwrite   = cmd_i[1];
  assign apb_if.paddr    = 32'hDEAD_CAFE;
  assign apb_if.pwdata   = rdata_q + 32'h1;

  // Capture the read data to store it for the next write
  always_ff @(posedge clk or posedge reset)
    if (reset)
      rdata_q <= 32'h0;
  else if (apb_if.penable && apb_if.pready)
      rdata_q <= apb_if.prdata;

endmodule
