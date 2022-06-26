module day14_tb ();

  localparam NUM_PORTS = 8;

  logic[NUM_PORTS-1:0] req_i;
  logic[NUM_PORTS-1:0] gnt_o;

  day14 #(NUM_PORTS) DAY14 (.*);

  initial begin
    for (int i=0; i<32; i=i+1) begin
      req_i = $urandom_range(0, 2**NUM_PORTS-1);
      #5;
    end
  end

  initial begin
    $dumpfile("day14.vcd");
    $dumpvars(0, day14_tb);
  end
  
endmodule
