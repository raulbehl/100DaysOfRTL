// Simple ALU TB

module day4_tb ();

  logic [7:0] a_i;
  logic [7:0] b_i;
  logic [2:0] op_i;
  logic [7:0] alu_o;

  day4 DAY4 (.*);

  initial begin
    for (int j =0; j<3; j++) begin
      for (int i =0; i<7; i++) begin
        a_i = $urandom_range(0, 8'hFF);
        b_i = $urandom_range(0, 8'hFF);
        op_i = 3'(i);
        #5;
      end
    end
  end

  initial begin
    $dumpfile("day4.vcd");
    $dumpvars(0, day4_tb);
  end
endmodule
