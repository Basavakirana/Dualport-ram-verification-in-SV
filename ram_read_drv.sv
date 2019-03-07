class ram_read_drv;

    virtual ram_if.RD_DRV rd_drv_if;

    ram_trans data2duv;

    mailbox #(ram_trans) gen2rddrv;

    function new(virtual ram_if.RD_DRV rd_drv_if,
                 mailbox #(ram_trans) gen2rddrv);
        this.rd_drv_if = rd_drv_if;
        this.gen2rddrv = gen2rddrv;
    endfunction

    virtual task start();
        fork
            forever
                begin
                    gen2rddrv.get(data2duv);
                    drive();
                end
        join_none
    endtask

    virtual task drive();
        @(rd_drv_if.rd_drv_cb);
        rd_drv_if.rd_drv_cb.read <= data2duv.read;
        rd_drv_if.rd_drv_cb.rd_addr <= data2duv.rd_addr;
        repeat(2)
                @(rd_drv_if.rd_drv_cb);
                rd_drv_if.rd_drv_cb.read <= 1'b0;
    endtask

endclass
