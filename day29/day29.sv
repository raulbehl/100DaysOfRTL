module day29();
  
  event pong;
  event ping;
  
  // Communicate between two initial blocks
  
  initial begin
    forever begin
      // Wait for event
      @ping;
      $display("%t: Ping", $time);
      // Wait for some time
      #1;
      // Drive pong event
      ->pong;
    end
  end
  
  initial begin
    forever begin
      // Wait for some time
      #1;
      // Drive ping event
      ->ping;
      // Wait for event
      @pong;
      $display("%t: Pong", $time);
    end
  end
  
  // Finish sim in some time
  initial begin
    #200;
    $finish();
  end
  
endmodule
