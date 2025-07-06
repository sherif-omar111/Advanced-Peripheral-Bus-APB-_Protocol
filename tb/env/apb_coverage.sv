`ifndef APB_COVERAGE_SV
    `define APB_COVERAGE_SV

class apb_coverage extends uvm_subscriber#(apb_seq_item);

  `uvm_component_utils(apb_coverage)

    uvm_analysis_imp#(apb_seq_item,apb_coverage) coverage_analysis_export;

    apb_seq_item item ;

 covergroup  APB_CVG ;

    APB_PRESETN       : coverpoint   item.presetn { bins presetn_bin[]  = { [0:1] }; } 
    APB_PWRITE        : coverpoint   item.pwrite  { bins pwrite_bin[]   = { [0:1] }; } 
    APB_psel          : coverpoint   item.psel    { bins ppsel_bin[]    = { [0:1] }; } 
    APB_penable       : coverpoint   item.penable { bins penable_bin[]  = { [0:1] }; } 
    APB_pready        : coverpoint   item.pready  { bins pready_bin[]   = { [0:1] }; } 
    APB_pslverr       : coverpoint   item.pslverr { bins pslverr_bin[]  = { [0:1] }; } 
    APB_paddr         : coverpoint   item.paddr   { bins paddr_bin[]    = { [0:31] }; } 
    APB_pwdata        : coverpoint   item.pwdata  { bins pwdata_zeros   = {0}; bins pwdata_b   = {[1:255]}; bins pwdata_ones   = {255}; } 
    // APB_prdata        : coverpoint   item.prdata  { bins prdata_bin[]   = { [0:255] }; }       

 endgroup

  function new(string name= "", uvm_component parent);
    super.new(name, parent);
    coverage_analysis_export = new("coverage_analysis_export",this);
     APB_CVG  = new();
  endfunction

function void build_phase (uvm_phase phase);
      `uvm_info(get_type_name(), $sformatf("We are in COVERAGE build phase"), UVM_LOW)
      super.build_phase(phase);
      item = apb_seq_item::type_id::create("item");
   endfunction

   function void write(apb_seq_item t);

     `uvm_info("DEBUG", $sformatf("Hello from COVERAGE WRITE FUNCTION"), UVM_NONE)
        item = t;
        APB_CVG.sample();

   endfunction 

   
    function void extract_phase(uvm_phase phase);
        super.extract_phase(phase);
        `uvm_info(get_type_name(), $sformatf("Coverage: %0.2f%%", APB_CVG.get_coverage()), UVM_NONE)
    endfunction

  endclass

`endif 