
`ifndef APB_IF_SV
  `define APB_IF_SV

interface apb_if (input clk);

  logic         presetn;
  logic         psel;
  logic         penable;
  logic         pwrite;
  logic [31:0]  paddr, pwdata;
  logic [31:0]  prdata;
  logic         pready, pslverr;

endinterface

`endif


