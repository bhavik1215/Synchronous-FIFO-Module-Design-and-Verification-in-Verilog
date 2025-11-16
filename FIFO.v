`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/01/2025 06:35:33 PM
// Design Name: 
// Module Name: FIFO
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
// Module Name = Synchronous_fifo
// Description = Synchronous fifo with fixed depth (8) and data width (8)

module synchronous_fifo
(clk,rst_n,wr_en_in,data_in,re_en_in,full_o,data_o,empty_o);


parameter DEPTH = 8;  // delclared parameter before parameterizing
parameter DATA_WIDTH = 8;
input clk;
input rst_n;
input wr_en_in ;
input[DATA_WIDTH-1:0]data_in;
input re_en_in;
output full_o;
output reg [DATA_WIDTH-1:0] data_o;
output empty_o;

writepointer_fulllogic write_dut(clk,wr_en_in,re_ptr,full_o,wr_ptr);
readpointer_emptylogic read_dut(clk,wr_ptr,re_ptr,empty_o);
fifomem fifomem_dut(wr_en_in ,re_en_in,data_in,wr_ptr,re_ptr,data_o,clk,rst_n);


endmodule

module fifomem(wr_en_in ,re_en_in,data_in,wr_ptr,re_ptr,data_o,clk,rst_n);

parameter DEPTH = 8;  // delclared parameter before parameterizing
parameter DATA_WIDTH = 8;
input wr_en_in;
input [3:0]data_in;
input [3:0]wr_ptr;
input clk;
input rst_n;
input re_en_in;
input [3:0]re_ptr;
output reg [3:0]data_o;
// FIFO memory : 8 entries of 8-bit data 
reg [DATA_WIDTH-1:0] mem [0: DATA_WIDTH-1];

always @( posedge clk) begin
 if (wr_en_in) begin
    mem[wr_ptr] <= data_in;
    end
 end
always@(posedge clk)
begin
if(re_en_in) begin
    data_o<=mem[re_ptr];
end
end
endmodule



module writepointer_fulllogic(clk,
wr_en_in,re_ptr,full_o,wr_ptr);
input clk;
input re_ptr;
input wr_en_in;
output reg [3:0]wr_ptr ;
output reg full_o;
 always @( posedge clk)
 begin
 full_o=({~wr_ptr[3],wr_ptr[2:0]}=={re_ptr});
 if (!full_o && wr_en_in) begin
    wr_ptr = wr_ptr+1;
    end
 end
 endmodule
  
module readpointer_emptylogic(
clk,wr_ptr,re_ptr,rd_en,empty_o);
input clk ;
input [3:0]wr_ptr;
input rd_en;
output reg [3:0]re_ptr;
output reg empty_o;
always @(posedge clk)
begin
empty_o = (wr_ptr[3:0]==re_ptr[3:0]);
if(!empty_o && rd_en) begin
    re_ptr = re_ptr+1;
    end
end
endmodule

