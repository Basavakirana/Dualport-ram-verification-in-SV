interface ram_if(input bit clk);
logic write,read;
logic [7:0]data_in;
logic [3:0]wr_addr,rd_addr;
logic [7:0]data_out;

clocking wr_drv_cb @(posedge clk);
    default input #1 output #1;
        output data_in;
        output write;
        output wr_addr;
endclocking

clocking wr_mon_cb @(posedge clk);
    default input #1 output #1;
        input data_in;
        input write;
        input wr_addr;
endclocking

clocking rd_drv_cb @(posedge clk);
    default input #1 output #1;
        output rd_addr;
        output read;
endclocking

clocking rd_mon_cb @(posedge clk);
    default input #1 output #1;
        input read;
        input rd_addr;
        input data_out;
endclocking

modport WR_DRV(clocking wr_drv_cb);

modport WR_MON(clocking wr_mon_cb);

modport RD_DRV(clocking rd_drv_cb);

modport RD_MON(clocking rd_mon_cb);

endinterface
