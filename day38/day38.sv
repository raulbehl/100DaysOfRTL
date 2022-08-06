// Wait fork with automatic variables

module day38();
  
  initial begin
    // Spawn multiple threads using a for loop
    fork
      begin
        for (int i=0; i<8; i++) begin
          // Copy the loop variable in an automatic variable
          automatic int j = i;
          fork
            begin
              print(j);
            end
          join_none
        end
        wait fork;
      end
    join
    $display("****After wait work*****");
  end
      
  task automatic print(int i);
	automatic int rand_delay;
    rand_delay = $urandom_range(1, 10);
    #rand_delay;
    $display("%t Thread[%0d] finished", $time, i);
  endtask
  
  
endmodule
