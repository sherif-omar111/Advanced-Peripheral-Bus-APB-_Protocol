`ifndef TEST_ALL_SV
    `define TEST_ALL_SV

class test_all extends test_base;

`uvm_component_utils(test_all)

function new (string name = "" , uvm_component parent);
    super.new(name,parent);
endfunction

apb_reset_sequence 		    reset_seq;
apb_write_sequence 		    write_seq;
apb_read_sequence 		    read_seq;
apb_error_sequence 		    error_seq;

virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    reset_seq   = apb_reset_sequence::type_id::create("reset_seq");
    write_seq   = apb_write_sequence::type_id::create("write_seq");
    read_seq    = apb_read_sequence::type_id::create("read_seq");
    error_seq   = apb_error_sequence::type_id::create("error_seq");

    endfunction

virtual task run_phase (uvm_phase phase);

    phase.raise_objection(this , "----------------------TEST STAETED----------------------");

    reset_seq.start(env.agent.sequencer);
    write_seq.start(env.agent.sequencer);
    read_seq.start(env.agent.sequencer);
    error_seq.start(env.agent.sequencer);

    #(100ns);

    phase.drop_objection(this, "----------------------TEST FINISHED----------------------"); 

endtask


endclass

`endif 
