// Wait fork

module day37();
  
  initial begin
    // Spawn multiple threads using a for loop
    fork
      begin
        for (int i=0; i<8; i++) begin
          fork
            begin
              print();
            end
          join_none
        end
        wait fork;
      end
    join
    $display("****After wait work*****");
  end
      
  task print();
	automatic int rand_delay;
    rand_delay = $urandom_range(1, 10);
    #rand_delay;
    $display("%t Thread finished", $time);
  endtask
  
  
endmodule
