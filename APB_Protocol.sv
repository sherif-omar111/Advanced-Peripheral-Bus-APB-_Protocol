/*=================================================================================================
 = File name : APB_Protocol.sv                                                                    =
 = Author    : Sherif Omar                                                                        =
 = Linkedin  : https://www.linkedin.com/in/sherif-omar-23829b222/                                 =
 = Email     : sherifomar661@gmail.com  "If you have any questions, feel free to contact me"      =
 = Date      : Sep 09 , 2022                                                                      =
 =================================================================================================*/

module APB_Protocol (
input   wire                clk ,
input   wire                rst,
input   wire                psel,
input   wire    [31:0]      paddr,
input   wire                pwrite,
input   wire                penable,
input   wire    [31:0]      pwdata,
output  reg     [31:0]      prdata,
output  reg                 pready               
);

typedef enum  { 
    IDLE,
    SETUP,
    ACCESS
} APB_STATE_enum;

//4 slaves
  reg [31:0]    reg1;
  reg [31:0]    reg2;
  reg [31:0]    reg3;
  reg [31:0]    reg4;

 reg        wr_en;  
 reg        rd_en;
 wire       reg1_en;
 wire       reg2_en;
 wire       reg3_en;
 wire       reg4_en;

 APB_STATE_enum apb_state ;

 always @(posedge clk or negedge rst) begin
    if (!rst) begin
        wr_en  <= 1'b0 ;
        rd_en  <= 1'b0 ;
        pready <= 1'b0 ;
        apb_state <= IDLE ;
        end
    else begin
        case (apb_state)
            IDLE : begin
                wr_en   <= 1'b0 ;
                rd_en   <= 1'b0 ;
                pready  <= 1'b0 ;
                if (psel) begin
                    apb_state <= SETUP ;
                end
            end
            SETUP : begin
                rd_en <= 1'b0 ;
                if (psel && penable) begin
                    apb_state <= ACCESS ;
                    if (pwrite) begin
                        wr_en <= 1'b1 ;
                    end
                end
                else begin
                    apb_state <= IDLE ;
                end
            end
            ACCESS : begin
                pready <= 1'b1 ;
                wr_en  <= 1'b0 ;
                if (pwrite == 0) begin
                    rd_en <= 1'b1 ;
                end
                apb_state <= IDLE ;
            end
            default : begin
                apb_state <= IDLE ;
            end
        endcase
    end   
 end

  assign reg1_en  = psel & (paddr == 32'h0000_0010);
  assign reg2_en  = psel & (paddr == 32'h0000_0014);
  assign reg3_en  = psel & (paddr == 32'h0000_0018);
  assign reg4_en  = psel & (paddr == 32'h0000_001c);

  assign pready   = 1'b1;
  assign wr_en    = penable & pwrite;
  assign rd_en    = penable & ~pwrite;

always @(posedge clk or negedge rst) begin
    if(!rst) begin
        reg1 <= 32'h0;
    end
    else if (wr_en && reg1_en) begin
        reg1 <= pwdata ;
    end
end


always @(posedge clk or negedge rst) begin
    if(!rst) begin
        reg2 <= 32'h0;
    end
    else if (wr_en && reg2_en) begin
        reg2 <= {28'h0, pwdata[3:0]} ;
    end
end


always @(posedge clk or negedge rst) begin
    if(!rst) begin
        reg3 <= 32'h0;
    end
    else if (wr_en && reg3_en) begin
        reg3 <= {pwdata[31:24], 16'h0, pwdata[7:0]} ;
    end
end


always @(posedge clk or negedge rst) begin
    if(!rst) begin
        reg4 <= 32'h0;
    end
    else if (wr_en && reg4_en) begin
        reg4 <= pwdata;
    end
end


always @(*) begin
    if(rd_en) begin
    if(reg1_en) begin
        prdata = reg1 ;
    end
    else if(reg2_en) begin
        prdata = reg2 ;
    end
    else if(reg3_en) begin
        prdata = reg3 ;
    end
    else if(reg4_en) begin
        prdata = 32'h0 ;
    end
    else begin
        prdata = 32'h0 ;
    end
end
end
endmodule