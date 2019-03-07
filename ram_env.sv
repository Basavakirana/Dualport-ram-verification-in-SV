class ram_env;

    virtual ram_if.RD_DRV rd_drv_if;
    virtual ram_if.WR_DRV wr_drv_if;
    virtual ram_if.RD_MON rd_mon_if;
    virtual ram_if.WR_MON wr_mon_if;

    mailbox #(ram_trans) gen2wrdrv;
    mailbox #(ram_trans) gen2rddrv;
    mailbox #(ram_trans) wrmon2rm;
    mailbox #(ram_trans) rdmon2rm;
    mailbox #(ram_trans) rdmon2sb;
    mailbox #(ram_trans) rm2sb;

    ram_gen         gen_h;
    ram_write_drv   wr_drv_h;
    ram_read_drv    rd_drv_h;
    ram_write_mon   wr_mon_h;
    ram_read_mon    rd_mon_h;
    ram_rm          rm_h;
    ram_sb          sb_h;

    function new(virtual ram_if.RD_DRV rd_drv_if,
                 virtual ram_if.WR_DRV wr_drv_if,
                 virtual ram_if.RD_MON rd_mon_if,
                 virtual ram_if.WR_MON wr_mon_if);
        this.rd_drv_if = rd_drv_if;
        this.wr_drv_if = wr_drv_if;
        this.rd_mon_if = rd_mon_if;
        this.wr_mon_if = wr_mon_if;
    endfunction

    virtual task build();
        gen_h = new(gen2wrdrv,gen2rddrv);
        wr_drv_h = new(wr_drv_if,gen2wrdrv);
        rd_drv_h = new(rd_drv_if,gen2rddrv);
        wr_mon_h = new(wr_mon_if,wrmon2rm);
        rd_mon_h = new(rd_mon_if,rdmon2rm,rdmon2sb);
        rm_h = new(wrmon2rm,rdmon2rm,rm2sb);
        sb_h = new(rdmon2sb,rm2sb);
    endtask

    virtual task run();
        reset_dut();
        start();
        stop();
        sb_h.report();
    endtask

    virtual task reset_dut();
        begin
            rd_drv_if.rd_drv_cb.rd_addr <= '0;
            rd_drv_if.rd_drv_cb.read <= '0;
            wr_drv_if.wr_drv_cb.wr_addr <= '0;
            wr_drv_if.wr_drv_cb.write <= '0;
            repeat(5)
                @(wr_drv_if.wr_drv_cb);
                for(int i=0;i<4096;i++)
                    begin
                        wr_drv_if.wr_drv_cb.write <= '1;
                        wr_drv_if.wr_drv_cb.wr_addr <= i;
                        wr_drv_if.wr_drv_cb.data_in <= '0;
                        @(wr_drv_if.wr_drv_cb);
                    end
                wr_drv_if.wr_drv_cb.write <= '0;
            repeat(5)
                @(wr_drv_if.wr_drv_cb);
         end
     endtask

     virtual task start();
        gen_h.start();
        wr_drv_h.start();
        rd_drv_h.start();
        wr_mon_h.start();
        rd_mon_h.start();
        rm_h.start();
        sb_h.start();
     endtask

     virtual task stop();
        wait(sb_h.done.triggered);
     endtask

endclass



