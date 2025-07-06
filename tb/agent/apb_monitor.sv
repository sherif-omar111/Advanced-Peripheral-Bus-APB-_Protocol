`ifndef APB_MONITOR_A_SV
  `define APB_MONITOR_A_SV

  class apb_monitor extends uvm_monitor;
  `uvm_component_utils(apb_monitor)

    virtual apb_if vif;

   apb_seq_item item;

   uvm_analysis_port  #(apb_seq_item) mon_analysis_port;

    
  function new(string name ="", uvm_component parent);
    super.new(name, parent);

    item = apb_seq_item::type_id::create("item");
    mon_analysis_port = new ("mon_analysis_port", this);

  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual apb_if)::get(this, "", "vif", vif))
      `uvm_fatal("MONITOR", "Could not get vif") 
  endfunction

virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);

    `uvm_info("DEBUG", $sformatf("Monitoring in monitor"), UVM_NONE)

    forever begin
        @(posedge vif.clk);
        #1step;
        item.presetn    = vif.presetn;
        item.pwrite     = vif.pwrite;
        item.paddr      = vif.paddr;
        item.pwdata     = vif.pwdata;
        item.psel       = vif.psel;
        item.penable    = vif.penable;
        item.prdata     = vif.prdata;
        item.pslverr    = vif.pslverr;
        item.pready     = vif.pready;
        `uvm_info(get_type_name(), $sformatf("Monitor: %0d", item.pslverr), UVM_NONE)
        
        mon_analysis_port.write(item); 
        end
        endtask

   endclass

`endif