// Function vs tasks

package day31_pkg;

function void print (logic[31:0] sum);
  $display("%t 0x%8x", $time, sum);
endfunction

task increment_after_delay (
  input logic[31:0] sum);
  
  // Wait for some time
  #5;
  // Print the incremented value
  print(sum+1);
  
endtask
endpackage

module day31_tb();
  
  // Import the package
  import day31_pkg::*;
  
  // Call the task in an initial block
  initial begin
    for (int i=0; i<512; i++) begin
      increment_after_delay (i);
    end
    $finish();
  end
  
endmodule
