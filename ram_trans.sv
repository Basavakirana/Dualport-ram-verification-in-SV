class ram_trans;

    rand bit read;
    rand bit write;
    rand bit [7:0]data_in;
    rand bit [3:0]wr_addr;
    rand bit [3:0]rd_addr;
    logic [7:0] data_out;

    static int no_of_trans;
    static int no_of_read_trans;
    static int no_of_write_trans;
    static int no_of_rw_trans;

    constraint valid_addr {wr_addr != rd_addr;}
    constraint valid_ctrl {{read,write} != 2'b00;}
    constraint valid_data {data_in inside {[1:4000]};}

    virtual function void display(input string message);
        $display("==================================================");
        $display("\t total no of trans:%d",no_of_trans);
        $display("\t total no od read trans:%d",no_of_read_trans);
        $display("\t total no of write trans:%d",no_of_write_trans);
        $display("\t total no of read write trans:%d",no_of_rw_trans);
        $display("\t read:%d,write:%d",read,write);
        $display("\t write address:%d,read address:%d",wr_addr,rd_addr);
        $display("\t input data:%d",data_in);
        $display("\t output data:%d",data_out);
        $display("=====================================================");
     endfunction

     function void post_randomize();
        if(this.read==1 && this.write==0)
            no_of_read_trans++;
        if(this.read==0 && this.write==1)
            no_of_write_trans++;
        if(this.read==1 && this.write==1)
            no_of_rw_trans++;
            this.display("\t randomized data");
     endfunction


function bit compare(input ram_trans rc_data,output string message);
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
endfunction
endclass
