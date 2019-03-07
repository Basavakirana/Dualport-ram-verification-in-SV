class ram_rm;

    ram_trans rdmon_data;
    ram_trans wrmon_data;

    logic [7:0]ref_data[int];

    mailbox #(ram_trans) wrmon2rm;
    mailbox #(ram_trans) rdmon2rm;
    mailbox #(ram_trans) rm2sb;

    function new(mailbox #(ram_trans) wrmon2rm,
                 mailbox #(ram_trans) rdmon2rm,
                 mailbox #(ram_trans) rm2sb);
        this.wrmon2rm = wrmon2rm;
        this.rdmon2rm = rdmon2rm;
        this.rm2sb = rm2sb;
    endfunction

    virtual task start();
        fork
            begin
                fork
                    begin
                        forever
                            begin
                                wrmon2rm.get(wrmon_data);
                                mem_write(wrmon_data);
                             end
                    end

                    begin
                        forever
                            begin
                                rdmon2rm.get(rdmon_data);
                                mem_read(rdmon_data);
                                rm2sb.put(rdmon_data);
                            end
                    end
                 join
               end
          join_none
      endtask

      virtual task mem_write(ram_trans wrmon_data);
        begin
            if(wrmon_data.write)
                    write1(wrmon_data);
        end
      endtask

      virtual task mem_read(ram_trans rdmon_data);
        begin
            if(rdmon_data.read)
                    read1(rdmon_data);
        end
      endtask

      virtual task write1(ram_trans wrmon_data);
        ref_data[wrmon_data.wr_addr] = wrmon_data.data_in;
      endtask

      virtual task read1(ram_trans rdmon_data);
        if(ref_data.exists(rdmon_data.wr_addr))
            rdmon_data.data_out = ref_data[rdmon_data.rd_addr];
      endtask
      endclass
