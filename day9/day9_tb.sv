module day9_tb ();

  parameter VEC_W = 5;

  logic [VEC_W-1:0] bin_i;
  logic [VEC_W-1:0] gray_o;

  day9 #(VEC_W) DAY9 (.*);

  initial begin
    for (int i=0; i<2**VEC_W; i=i+1) begin
      bin_i = i;
      #5;
    end
    $finish();
  end

  initial begin
    $dumpfile("day9.vcd");
    $dumpvars(2, day9_tb);
  end

endmodule
