// A simple TB for mux

module day1_tb ();

  logic [7:0] a_i;
  logic [7:0] b_i;
  logic       sel_i;
  logic [7:0] y_o;

  day1 DAY1 (.*);

  initial begin
    for (int i = 0; i < 10; i++) begin
      a_i   = $urandom_range (0, 8'hFF);
      b_i   = $urandom_range (0, 8'hFF);
      sel_i = $random%2;
      #5;
    end
  end

  initial begin
    $dumpfile("day1.vcd");
    $dumpvars(0, day1_tb);
  end

endmodule
