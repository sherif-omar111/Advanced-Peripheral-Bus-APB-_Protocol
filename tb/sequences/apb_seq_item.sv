`ifndef APB_SEQ_ITEM_SV
    `define APB_SEQ_ITEM_SV

class apb_seq_item extends uvm_sequence_item;
    `uvm_object_utils(apb_seq_item)

    // input signals
    rand    logic           presetn;
    rand    logic           pwrite;
    randc   logic [31:0]    paddr;
    rand    int             pwdata;
    rand    logic           penable;
    rand    logic           psel;

    // output signals
    logic [31:0]       prdata;
    logic              pslverr;
    logic              pready;

    bit hard_reset ; 

    constraint addr_c {paddr < 32;}

    constraint addr_c_err {paddr > 32;}

virtual function string convert2string();

    string result =  $sformatf("presetn = %0d pwrite= %0d paddr = %0d pwdata = %0d penable = %0d psel = %0d prdata = %0d pslverr = %0d pready = %0d", presetn,pwrite,paddr,pwdata,penable,psel,prdata,pslverr,pready);

    return result;

  endfunction

function new (string name = "" );
    super.new(name);
endfunction

endclass

`endif 