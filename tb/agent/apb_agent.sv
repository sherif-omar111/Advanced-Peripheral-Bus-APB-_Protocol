`ifndef APB_AGENT_SV
    `define APB_AGENT_SV

class apb_agent extends uvm_agent;

//Driver handler
apb_driver driver;

//Sequencer handler
apb_sequencer sequencer;

//Monitor handler
apb_monitor monitor;

`uvm_component_utils(apb_agent)

function new (string name = "" , uvm_component parent);
    super.new(name,parent);
endfunction

virtual function void build_phase(uvm_phase phase);
super.build_phase (phase);

    driver      = apb_driver::type_id::create("driver", this);
    sequencer   = apb_sequencer::type_id::create("sequencer", this);
    monitor     = apb_monitor::type_id::create("monitor", this);

endfunction

virtual function void connect_phase (uvm_phase phase);

    super.connect_phase(phase);
    `uvm_info("DEBUG", $sformatf("Hello from apb agent connect phase"), UVM_NONE)

    driver.seq_item_port.connect(sequencer.seq_item_export);

    endfunction
    
endclass

`endif 

