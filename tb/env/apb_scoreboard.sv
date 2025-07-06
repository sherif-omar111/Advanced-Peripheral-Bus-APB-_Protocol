`ifndef APB_SCOREBOARD_SV
    `define APB_SCOREBOARD_SV

class apb_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(apb_scoreboard)

  apb_seq_item item;
  uvm_analysis_imp #(apb_seq_item, apb_scoreboard) sc_analysis_imp;

  int unsigned passed_cases = 0;
  int unsigned failed_cases = 0;

  logic [31:0] ref_mem[32] = '{default:0};
  logic [31:0] ref_dout = 0;

    function new(string name= "", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
    sc_analysis_imp = new("sc_analysis_imp", this);         
    endfunction

function void write(apb_seq_item t);
        item = t;
          if (item.pwrite == 1)  //write operation
          begin
              if (item.pslverr == 1) begin
                  `uvm_info(get_type_name(), $sformatf("ERROR DETECTED: %0d", item.pslverr), UVM_NONE)
                  failed_cases++;
              end
              else begin
                  ref_mem[item.paddr] = item.pwdata;
                  `uvm_info(get_type_name(), $sformatf("WRITE OPERATION: %0d", item.pwdata), UVM_NONE)
                  `uvm_info(get_type_name(), $sformatf("ref_mem[%0d]: %0d", item.paddr, ref_mem[item.paddr]), UVM_NONE)
                  ref_dout = ref_mem[item.paddr];
              end
          end
          else if (item.pwrite == 0 ) begin //read operation
              if (item.pslverr == 1) begin
                  `uvm_info(get_type_name(), $sformatf("ERROR DETECTED: %0d", item.pslverr), UVM_NONE)
                  failed_cases++;
              end
              else begin 
                  if (ref_dout == item.prdata) begin
                      passed_cases++;
                      `uvm_info(get_type_name(), $sformatf("PASSED CASE: %0d", passed_cases), UVM_NONE)
                      `uvm_info(get_type_name(), $sformatf("ref_dout: %0d", ref_dout), UVM_NONE)
                      `uvm_info(get_type_name(), $sformatf("item.prdata: %0d", item.prdata), UVM_NONE)
                  end
                  else begin
                      failed_cases++;
                      `uvm_info(get_type_name(), $sformatf("FAILED CASE: %0d", failed_cases), UVM_NONE)
                      `uvm_info(get_type_name(), $sformatf("ref_dout: %0d item.prdata: %0d ", ref_dout, item.prdata ), UVM_NONE)
                  end
              end
          end
      
    endfunction

    function void extract_phase(uvm_phase phase);
        super.extract_phase(phase);
        `uvm_info(get_type_name(), $sformatf("PASSED CASE: %0d", passed_cases), UVM_NONE)
        `uvm_info(get_type_name(), $sformatf("FAILED CASE: %0d", failed_cases), UVM_NONE)
    endfunction

  endclass

`endif 
