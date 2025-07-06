`ifndef APB_RESET_SEQUENCE_SV
    `define APB_RESET_SEQUENCE_SV

class apb_reset_sequence extends uvm_sequence#(.REQ(apb_seq_item));

//Item to drive
apb_seq_item item;

`uvm_object_utils(apb_reset_sequence)

function new (string name = "");
    super.new(name);
endfunction

virtual task body();
      item = apb_seq_item::type_id::create("item");

    	start_item(item);
      item.hard_reset = 1 ;
      finish_item(item);

  endtask

  endclass

`endif 