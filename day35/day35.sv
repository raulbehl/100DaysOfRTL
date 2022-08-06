// Fork and Join_none

module day35();
  
  initial begin
    
    // Fork three different processes
    fork
    begin
      $display("%t T0 Starting...", $time);
      #5;
      $display("%t T0 Finished", $time);
    end
    
    begin
      $display("%t T1 Starting...", $time);
      #2;
      $display("%t T1 Finished", $time);
    end
    
    begin
      $display("%t T2 Starting...", $time);
      #7;
      $display("%t T2 Finished", $time);
    end
    join_none
    $display("%t ****After fork..join_none****", $time);
  	// Wait for some time before calling $finish
    #20;
    $finish();
  end
  
endmodule
