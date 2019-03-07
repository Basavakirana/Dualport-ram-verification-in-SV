class ram_gen;

    ram_trans gen_trans;
    ram_trans data2send;

    mailbox #(ram_trans) gen2wrdrv;
    mailbox #(ram_trans) gen2rddrv;
    int number_of_transactions=0;

    function new(mailbox #(ram_trans) gen2wrdrv,
                 mailbox #(ram_trans) gen2rddrv);
        this.gen2wrdrv = gen2wrdrv;
        this.gen2rddrv = gen2rddrv;
        this.gen_trans = new();
    endfunction

    virtual task start();
        fork
            begin
                for(int i=0;i<number_of_transactions;i++)
                    begin
                        gen_trans.no_of_trans++;
                        assert(gen_trans.randomize);
                        data2send = new gen_trans;
                        gen2wrdrv.put(data2send);
                        gen2rddrv.put(data2send);
                    end
             end
        join_none
     endtask

endclass

