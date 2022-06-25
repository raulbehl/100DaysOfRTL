// Various ways to implement a mux

module day13 (
  input     wire[3:0] a_i,
  input     wire[3:0] sel_i,

  // Output using ternary operator
  output    wire     y_ter_o,
  // Output using case
  output    logic     y_case_o,
  // Ouput using if-else
  output    logic     y_ifelse_o,
  // Output using for loop
  output    logic     y_loop_o,
  // Output using and-or tree
  output    logic     y_aor_o
);

  // Ternary operator
  assign y_ter_o = sel_i[0] ? a_i[0] :
                   sel_i[1] ? a_i[1] :
                   sel_i[2] ? a_i[2] :
                              a_i[3];

  // Using case
  always_comb begin
    case (sel_i)
      4'b0001 : y_case_o = a_i[0];
      4'b0010 : y_case_o = a_i[1];
      4'b0100 : y_case_o = a_i[2];
      4'b1000 : y_case_o = a_i[3];
      default : y_case_o = 1'bx;
    endcase
  end

  // Using ifelse
  always_comb begin
    if (sel_i[0])      y_ifelse_o = a_i[0];
    else if (sel_i[1]) y_ifelse_o = a_i[1];
    else if (sel_i[2]) y_ifelse_o = a_i[2];
    else if (sel_i[3]) y_ifelse_o = a_i[3];
    else               y_ifelse_o = 1'bx;
  end

  // Using for loop
  always_comb begin
    y_loop_o = '0;
    for (int i=0; i<4; i++) begin
      y_loop_o = (sel_i[i] & a_i[i]) | y_loop_o;
    end
  end

  // Using and-or tree
  assign y_aor_o = (sel_i[0] & a_i[0]) |
                   (sel_i[1] & a_i[1]) |
                   (sel_i[2] & a_i[2]) |
                   (sel_i[3] & a_i[3]);

endmodule
