`ifndef APB_DRIVER_SV
    `define APB_DRIVER_SV

class apb_driver extends uvm_driver#(.REQ(apb_seq_item));

`uvm_component_utils(apb_driver)

function new (string name = "" , uvm_component parent);
    super.new(name,parent);
endfunction

virtual apb_if vif;

apb_seq_item item;

virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual apb_if)::get(this, "", "vif", vif))
      `uvm_fatal("DRIVER", "Could not get vif")
  endfunction
  
virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);

    #(100ns);

    `uvm_info("DEBUG", $sformatf("Hello from DRIVER connect phase"), UVM_NONE)
    forever begin
        seq_item_port.get_next_item(item);
            
            `uvm_info("DRIVER", $sformatf("Wait for item from sequencer"), UVM_HIGH)
            if (item.hard_reset) begin
                    do_reset();
            end

            drive_item(item);

            `uvm_info("DEBUG", $sformatf("Driving \"%0s\": %0s", item.get_full_name(), item.convert2string()), UVM_NONE)  
           
        seq_item_port.item_done();

        end
    endtask

virtual task drive_item(apb_seq_item item);
        @(posedge vif.clk);
        vif.psel    <= item.psel;
        vif.pwrite  <= item.pwrite;
        vif.paddr   <= item.paddr;
        vif.pwdata  <= item.pwdata;
        vif.penable <= item.penable;
        #1step;
  endtask

  task do_reset();
  `uvm_info("DEBUG", $sformatf("Hello from do reset task"), UVM_NONE)
    vif.pwrite  <= 0;
    vif.paddr   <= 0;
    vif.pwdata  <= 0;
    vif.psel    <= 0;
    vif.penable <= 0;
    vif.presetn <= 0;
    repeat(2) begin
    @(posedge vif.clk);
    end
    vif.presetn <= 1; 
  endtask

endclass

`endif