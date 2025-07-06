module apb_assertions (
   input  wire          presetn,     
   input  wire          pclk,       
   input  wire          psel,       
   input  wire          penable,         
   input  wire          pwrite,         
   input  wire  [31:0]  paddr,     
   input  wire  [31:0]  pwdata,     
   input  wire  [31:0]  prdata,     
   input  wire          pready,     
   input  wire          pslverr
   );

property reset_check;
  @(negedge presetn) 1'b1 |-> @(posedge pclk) (psel == 0 && penable == 0 && pwrite == 0 && paddr == 0 && pwdata == 0);
endproperty

reset_check_assert: assert property(reset_check)
  else $error("Assertion reset_check failed!");

endmodule