// UVM Analysis Port

`include "uvm_macros.svh"

import uvm_pkg::*;

class sender extends uvm_component;
  
  `uvm_component_utils (sender);
  
  // Implement an analysis port of type int
  uvm_analysis_port #(int) sender_ap;
  
  // New function
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    sender_ap = new("analysis_port", this);
  endfunction
  
  virtual task run_phase (uvm_phase phase);
    
    int rand_num;
    // Keep on sending transactions until number 42 is seen
    // or 50 transactions are sent
    for (int i=0; i<50; i++) begin
      rand_num = $urandom_range(0, 100);
      // Broadcast the number via the analysis port to all the subscribers
      sender_ap.write(rand_num);
      if (rand_num == 42) break;
    end
    
  endtask
  
endclass

// Implement the subscriber classes
class sub1 #(type T = int) extends uvm_subscriber #(T);
  
  `uvm_component_utils (sub1);
  
  // New
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  // Build phase 
  virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
  // Implement the write function
  virtual function void write (T t);
    
    string sub1_print;
    
    sub1_print = $sformatf("Got a new transaction. %3d", t);
    
    `uvm_info("SUB1", sub1_print, UVM_LOW)
    
  endfunction
  
endclass

// Implement another subscriber
class sub2 #(type T = int) extends uvm_subscriber #(T);
  
  `uvm_component_utils (sub2);
  
  // New
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  // Build phase 
  virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
  // Implement the write function
  virtual function void write (T t);
    
    string sub2_print;
    
    sub2_print = $sformatf("Got a new transaction. %3d", t);
    
    `uvm_info("SUB2", sub2_print, UVM_LOW)
    
  endfunction
  
endclass

// Test class to build and connect various components
class day57_test extends uvm_test;
  
  `uvm_component_utils (day57_test)
  
  sender SEND;
  sub1   SUB1;
  sub2   SUB2;
  
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  // Build sender and subscriber classes
  virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    SEND = sender::type_id::create("SEND", this);
    SUB1 = sub1#(int)::type_id::create("sub1", this);
    SUB2 = sub2#(int)::type_id::create("sub2", this);
  endfunction
  
  // Connect sender's analysis port to subscriber classes
  virtual function void connect_phase (uvm_phase phase);
    
    SEND.sender_ap.connect (SUB1.analysis_export);
    SEND.sender_ap.connect (SUB2.analysis_export);
  endfunction
  
endclass

// TB module to start the test
module day57_tb ();
  
  initial begin
    run_test ("day57_test");
  end
  
endmodule

