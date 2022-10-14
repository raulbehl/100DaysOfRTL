module riscv_regfile (
  input			wire			clk,
  input			wire			reset,

  // Single write address
  input			wire			rf_wr_en_i,
  input			wire[4:0]		rf_wr_addr_i,
  input			wire[31:0]		rf_wr_data_i,
  
  // Two read addresses
  input			wire[4:0]		rf_rd_p0_i,
  input			wire[4:0]		rf_rd_p1_i,
  output		wire[31:0]		rf_rd_p0_data_o,
  output		wire[31:0]		rf_rd_p1_data_o,
);
  
  // Register file
  logic [31:0] reg_file [31:0];
  
  // Write logic
  always_ff @(posedge clk)
    if (rf_wr_en_i)
      reg_file[rf_wr_addr_i] <= rf_wr_data_i;
  
  // Read logic
  assign rf_rd_p0_data_o = 32'(|rf_rd_p0_i) & reg_file[rf_rd_p0_i];
  assign rf_rd_p0_data_o = 32'(|rf_rd_p1_i) & reg_file[rf_rd_p1_i];
  
endmodule
