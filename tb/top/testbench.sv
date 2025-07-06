import uvm_pkg::*;

`include "uvm_macros.svh"
`include "apb_assertions.sv"
`include "apb_if.sv"
`include "apb_seq_item.sv"
`include "apb_reset_sequence.sv"
`include "apb_write_sequence.sv"
`include "apb_error_sequence.sv"
`include "apb_read_sequence.sv"
`include "apb_sequencer.sv"
`include "apb_driver.sv"
`include "apb_monitor.sv"
`include "apb_agent.sv"
`include "apb_scoreboard.sv"
`include "apb_coverage.sv"
`include "apb_env.sv"
`include "test_base.sv"
`include "test_all.sv"

module testbench;

  reg clk;

initial begin 
    clk = 0 ;
    forever begin
    clk = #10ns ~clk ;
    end 
end 

apb_if vif (clk);

initial begin
$dumpfile ("dump.vcd");
$dumpvars;

uvm_config_db#(virtual apb_if)::set(null, "", "vif", vif);

// start uvm test and phases
run_test ("test_all");
end

	APB_Protocol DUT (                              
                    .presetn(vif.presetn),     
                    .pclk(clk),      
                    .psel(vif.psel),      
                    .penable(vif.penable),   
                    .pwrite(vif.pwrite), 
                    .paddr(vif.paddr),    
                    .pwdata(vif.pwdata),  
                    .prdata(vif.prdata),
                    .pready(vif.pready),
                    .pslverr(vif.pslverr)
                    );

bind APB_Protocol apb_assertions apb_assert (.*);

endmodule


