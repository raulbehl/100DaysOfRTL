// Fork and join

module day33 ();
  
  initial begin
    // Fork different threads
    fork
      // T0
      begin
        print(0, "Starting..");
        // Wait for some time
        #15;
        // Finsih
        print(0, "Finished.");
      end
      
      // T1
      begin
        print(1, "Starting..");
        #35;
        print(1, "Finished.");
      end
      
      // T2
      begin
        print(2, "Starting..");
        #30;
        print(2, "Finished");
      end
    join
    $display("%t Finished..", $time);
  end
  
  function automatic void print(int thread_num, string msg);
    $display("%t T%1d %s", $time, thread_num, msg);
  endfunction
  
endmodule
