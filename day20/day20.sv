// A useless system

module day20 (
  input       wire        clk,
  input       wire        reset,

  input       wire        read_i,
  input       wire        write_i,

  output      wire        rd_valid_o,
  output      wire[31:0]  rd_data_o
);

  logic         rd_gnt;
  logic         wr_gnt;

  // Arbitrate between reads and writes
  day14 #(.NUM_PORTS(2)) arb (
    .req_i          ({read_i, write_i}),    // Write given more priority
    .gnt_o          ({rd_gnt, wr_gnt})
  );

  logic         push;
  logic         pop;
  logic [1:0]   push_data;
  logic [1:0]   pop_data;
  logic         full;
  logic         empty;

  logic         psel;
  logic         penable;
  logic         pwrite;
  logic[31:0]   paddr;
  logic[31:0]   pwdata;
  logic         pready;
  logic[31:0]   prdata;

  assign push = |{rd_gnt, wr_gnt};

  // Push data is the decoded cmd
  assign push_data = {wr_gnt, rd_gnt};

  // Pop whenever downstream is free
  assign pop = ~empty & ~(psel & penable);

  // Send the granted request to fifo
  day19 #(.DEPTH(16), .DATA_W(2)) fifo (
    .clk            (clk),
    .reset          (reset),
    .push_i         (push),
    .push_data_i    (push_data),
    .pop_i          (pop),
    .pop_data_o     (pop_data),
    .full_o         (full),
    .empty_o        (empty)
  );

  // Instantiate the APB Master
  day16 apb_master (
    .clk            (clk),
    .reset          (reset),
    .cmd_i          (pop_data),
    .psel_o         (psel),
    .penable_o      (penable),
    .paddr_o        (paddr),
    .pwrite_o       (pwrite),
    .pwdata_o       (pwdata),
    .pready_i       (pready),
    .prdata_i       (prdata)
  );

  // Instantiate the APB Slave
  day18 apb_slave (
    .clk            (clk),
    .reset          (reset),
    .psel_i         (psel),
    .penable_i      (penable),
    .paddr_i        (paddr[9:0]),
    .pwrite_i       (pwrite),
    .pwdata_i       (pwdata),
    .pready_o       (pready),
    .prdata_o       (prdata)
  );

  assign rd_valid_o = pready & ~pwrite;
  assign rd_data_o  = {32{rd_valid_o}} & prdata;

endmodule
