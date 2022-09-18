class riscv_tb_mem;
  
  // Associative array to store write data
  bit[31:0] dmem [bit[31:0]];
  
  function bit[31:0] read (bit[31:0] addr);
    bit [31:0] rd_data;
    
    rd_data = dmem[addr];
    return rd_data;
  endfunction
  
  function void write(bit[31:0] addr, bit[31:0] wr_data);
    dmem[addr] = wr_data;
  endfunction
  
endclass