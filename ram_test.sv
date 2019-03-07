class ram_test;

    virtual ram_if.RD_DRV rd_drv_if;
    virtual ram_if.WR_DRV wr_drv_if;
    virtual ram_if.RD_MON rd_mon_if;
    virtual ram_if.WR_MON wr_mon_if;

    ram_env env_h;

    function new(virtual ram_if.RD_DRV rd_drv_if,
                 virtual ram_if.WR_DRV wr_drv_if,
                 virtual ram_if.RD_MON rd_mon_if,
                 virtual ram_if.WR_MON wr_mon_if);
            this.rd_drv_if = rd_drv_if;
            this.wr_drv_if = wr_drv_if;
            this.rd_mon_if = rd_mon_if;
            this.wr_mon_if = wr_mon_if;
            env_h = new(rd_drv_if,wr_drv_if,rd_mon_if,wr_mon_if);
    endfunction

    virtual task build();
        env_h.build();
    endtask

    virtual task run();
        env_h.run();
    endtask

endclass
