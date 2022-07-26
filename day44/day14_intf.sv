// Simple interface for a mux

interface day14_if #(parameter NUM_PORTS = 8)();

  logic [NUM_PORTS-1:0] req;
  logic [NUM_PORTS-1:0] gnt;

endinterface
