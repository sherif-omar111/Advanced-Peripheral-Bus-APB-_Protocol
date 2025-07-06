`ifndef APB_ERROR_SEQUENCE_SV
    `define APB_ERROR_SEQUENCE_SV

class apb_error_sequence extends uvm_sequence#(.REQ(apb_seq_item));

//Item to drive
apb_seq_item item;

`uvm_object_utils(apb_error_sequence)

function new (string name = "");
    super.new(name);
endfunction

task pre_body();
        item = apb_seq_item::type_id::create("item");
endtask


task body();
            start_item(item);
            item.addr_c.constraint_mode(0);
            item.addr_c_err.constraint_mode(1);
            void'(item.randomize() with {
                                  presetn == 1;
                                  psel == 1;
                                  penable == 1;});
            finish_item(item);
    endtask

  endclass

`endif 
