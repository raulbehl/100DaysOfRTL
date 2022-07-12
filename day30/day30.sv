module day30();
  
  mailbox pong;
  mailbox ping;
  
  int sum;
  
  // Communicate between two initial blocks
  
  initial begin
    sum = 0;
    forever begin
      // Wait for mailbox
      ping.get(sum);
      $display("%t: Sum: 0x%8x", $time, sum);
      // Wait for some time
      #1;
      // Increment sum
      sum++;
      // Put the new sum into the mailbox
      pong.put(sum);
    end
  end
  
  initial begin
    forever begin
      // Wait for some time
      #1;
      // Put into the ping mailbox
      ping.put(sum);
      // Wait for the pong mailbox
      pong.get(sum);
      // Increment the sum
      sum++;
      $display("%t: Sum: 0x%8x", $time, sum);
    end
  end
  
  // Finish sim in some time
  initial begin
    #200;
    $finish();
  end
  
endmodule
