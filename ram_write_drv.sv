class ram_write_drv;

    virtual ram_if.WR_DRV wr_drv_if;

    ram_trans data2duv;

    mailbox #(ram_trans) gen2wrdrv;

    function new(virtual ram_if.WR_DRV wr_drv_if,
                 mailbox #(ram_trans) gen2wrdrv);
        this.wr_drv_if = wr_drv_if;
        this.gen2wrdrv = gen2wrdrv;
    endfunction

    virtual task start();
        fork
            forever
                begin
                    gen2wrdrv.get(data2duv);
                    drive();
                end
         join_none
    endtask

    virtual task drive();
        @(wr_drv_if.wr_drv_cb);
        wr_drv_if.wr_drv_cb.write <= data2duv.write;
        wr_drv_if.wr_drv_cb.wr_addr <= data2duv.wr_addr;
        wr_drv_if.wr_drv_cb.data_in <= data2duv.data_in;
        repeat(2)
            @(wr_drv_if.wr_drv_cb);
            wr_drv_if.wr_drv_cb.write <= 1'b0;
     endtask

endclass
