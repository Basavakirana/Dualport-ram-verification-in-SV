module dualport_ram(clk,read,write,wr_addr,rd_addr,data_in,data_out);
parameter width = 8;
parameter depth = 16;
parameter size = 4;
input clk,read,write;
input [width-1:0]data_in;
input [size-1:0]wr_addr,rd_addr;
output reg [width-1:0]data_out;
integer i;
reg[width-1:0]mem[depth-1:0];

always@(posedge clk)
begin
    for(i=0;i<=depth;i=i+1)
    begin
        mem[i]<=0;
        data_out<=0;
    end

    begin
        if(write)
            mem[wr_addr]<=data_in;
        if(read)
            data_out<=mem[rd_addr];
    end
end
endmodule
