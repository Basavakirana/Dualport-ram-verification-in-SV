class ram_sb;

    event done;

    int data_verified = 0;
    int rm_data_count =0;
    int rdmon_data_count = 0;
    int number_of_transactions;

    ram_trans rm_data;
    ram_trans rdmon_rcvd_data;
    ram_trans cov_data;

    mailbox #(ram_trans) rm2sb;
    mailbox #(ram_trans) rdmon2sb;

    covergroup mem_coverage;

         WR_ADD : coverpoint cov_data.wr_addr{
                    bins zero   ={0};
                    bins low1   ={[1:500]};
                    bins low2   ={[501:1000]};
                    bins midlow ={[1001:1500]};
                    bins mid    ={[1501:2000]};
                    bins midhigh={[2001:2500]};
                    bins high1  ={[2501:3000]};
                    bins high2  ={[3001:4094]};
                    bins max    ={4095};}

         DATA : coverpoint cov_data.data_in{
                    bins zero   ={0};
                    bins low1   ={[1:500]};
                    bins low2   ={[501:1000]};
                    bins midlow ={[1001:1500]};
                    bins mid    ={[1501:2000]};
                    bins midhigh={[2001:2500]};
                    bins high1  ={[2501:3000]};
                    bins high2  ={[3001:4194]};
                    bins max    ={4195};}

         WR : coverpoint cov_data.write;

         wraddxipdataxwrt : cross WR_ADD,DATA,WR;

         RD_ADD : coverpoint cov_data.rd_addr{
                    bins zero   ={0};
                    bins low1   ={[1:500]};
                    bins low2   ={[501:1000]};
                    bins midlow ={[1000:1500]};
                    bins mid    ={[1501:2000]};
                    bins midhigh={[2001:2500]};
                    bins high1  ={[2501:3000]};
                    bins high2  ={[3001:4094]};
                    bins max    ={4095};}

         RD : coverpoint cov_data.read;

         rdaddxred : cross RD_ADD,RD;

    endgroup

    function new(mailbox #(ram_trans) rm2sb,
             mailbox #(ram_trans) rdmon2sb);
        this.rm2sb = rm2sb;
        this.rdmon2sb = rdmon2sb;
        mem_coverage = new();
    endfunction

    virtual task start();
        fork
            while(1)
                begin
                    rm2sb.get(rm_data);
                    rm_data_count++;
                    rdmon2sb.get(rdmon_rcvd_data);
                    rdmon_data_count++;
                    check(rdmon_rcvd_data);
                end
        join_none
     endtask


/*function bit compare(input ram_trans rc_data,output string message);
    compare = '0;
    begin
        if(this.rd_addr != rc_data.rd_addr)
            begin
                $display($time);
                message = "address mismatch";
                return(0);
            end
        if(this.data_out != rc_data.data_out)
            begin
                $display($time);
                message = "output mismatch";
                return(0);
            end
        begin
            message = "compare successful";
            return(1);
        end
    end
endfunction   */

    virtual task check(ram_trans rcvd_data);
        string diff;
        if(rcvd_data.read==1 && rcvd_data.data_out==0)
            $display("SB:random data is not written");
        else if(rcvd_data.read==1 && rcvd_data.data_out!=0)
            begin
                if(!rm_data.compare(rcvd_data,diff))
                    begin
                        rcvd_data.display("SB: recieved data is");
                        rm_data.display("SB: data sent to DUT is");
                    end
               else
                   $display("SB: %s\n\%m\n\n",diff);
             end
                cov_data = new rm_data;
                mem_coverage.sample();
                data_verified++;
            if(data_verified >= (number_of_transactions - rcvd_data.no_of_write_trans))
                begin
                    ->done;
                end
      endtask

     virtual function void report();
        $display("==========scoreboard report====================");
        $display("%d read data generated, %d recieved data recieved, %d read data verified \n",rm_data_count,rdmon_data_count,data_verified);
        $display("=================================================");
     endfunction

endclass
    
