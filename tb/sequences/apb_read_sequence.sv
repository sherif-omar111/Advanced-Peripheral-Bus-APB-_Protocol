`ifndef APB_READ_SEQUENCE_SV
    `define APB_READ_SEQUENCE_SV

class apb_read_sequence extends uvm_sequence#(.REQ(apb_seq_item));

//Item to drive
apb_seq_item item;

int loop_var = 32;

`uvm_object_utils(apb_read_sequence)

function new (string name = "");
    super.new(name);
endfunction

task pre_body();
        item = apb_seq_item::type_id::create("item");
endtask


virtual task body();

      for(int i = 0; i < loop_var; i++) begin

            start_item(item);

            item.addr_c_err.constraint_mode(0);
            item.addr_c.constraint_mode(1);
            void'(item.randomize() with {
                                pwrite == 0;
                                presetn == 1;
                                psel == 1;
                                penable == 1;});
            finish_item(item);
        end

  endtask

  endclass

`endif 
