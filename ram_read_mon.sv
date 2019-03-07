class ram_read_mon;

    virtual ram_if.RD_MON rd_mon_if;

    ram_trans data2rm;
    ram_trans data2sb;
    ram_trans rddata;

    mailbox #(ram_trans) rdmon2rm;
    mailbox #(ram_trans) rdmon2sb;

    function new(virtual ram_if.RD_MON rd_mon_if,
                 mailbox #(ram_trans) rdmon2rm,
                 mailbox #(ram_trans) rdmon2sb);
        this.rd_mon_if = rd_mon_if;
        this.rdmon2rm = rdmon2rm;
        this.rdmon2sb = rdmon2sb;
        this.rddata = new();
    endfunction

    virtual task start();
        fork
            forever
                begin
                    monitor();
                    data2rm = new rddata;
                    data2sb = new rddata;
                    rdmon2rm.put(data2rm);
                    rdmon2sb.put(data2sb);
                end
        join_none
     endtask

     virtual task monitor();
        @(rd_mon_if.rd_mon_cb);
        wait (rd_mon_if.rd_mon_cb.read ==1)
        @(rd_mon_if.rd_mon_cb);
        begin
            rddata.read = rd_mon_if.rd_mon_cb.read;
            rddata.rd_addr = rd_mon_if.rd_mon_cb.rd_addr;
            rddata.data_out = rd_mon_if.rd_mon_cb.data_out;
            rddata.display("\t data from read monitor");
        end
     endtask

endclass

