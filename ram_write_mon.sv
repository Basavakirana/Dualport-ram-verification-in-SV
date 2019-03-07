class ram_write_mon;

    virtual ram_if.WR_MON wr_mon_if;

    ram_trans data2rm;
    ram_trans wrdata;

    mailbox #(ram_trans) wrmon2rm;

    function new(virtual ram_if.WR_MON wr_mon_if,
                 mailbox #(ram_trans) wrmon2rm);
        this.wr_mon_if = wr_mon_if;
        this.wrmon2rm = wrmon2rm;
        this.wrdata = new();
    endfunction

    virtual task start();
        fork
            forever
                begin
                    monitor();
                    data2rm = new wrdata;
                    wrmon2rm.put(data2rm);
                end
         join_none
     endtask

     virtual task monitor();
        @(wr_mon_if.wr_mon_cb);
        wait (wr_mon_if.wr_mon_cb.write == 1)
        @(wr_mon_if.wr_mon_cb);
        begin
            wrdata.write = wr_mon_if.wr_mon_cb.write;
            wrdata.wr_addr = wr_mon_if.wr_mon_cb.wr_addr;
            wrdata.data_in = wr_mon_if.wr_mon_cb.data_in;
            wrdata.display("\t data from write monitor");
        end
     endtask

endclass
