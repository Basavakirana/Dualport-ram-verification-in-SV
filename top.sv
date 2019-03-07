module top();

 //   import ram_pkg::*;
int number_of_transactions;
    parameter cycle = 10;
    
    reg clock;

    ram_if DUV_IF (clock);

    ram_test test_h;

    dualport_ram DUT (.clk(clock),
                      .data_in(DUV_IF.data_in),
                      .wr_addr(DUV_IF.wr_addr),
                      .rd_addr(DUV_IF.rd_addr),
                      .read(DUV_IF.read),
                      .write(DUV_IF.write));

    initial
        begin
            clock = 1'b0;
            forever #(cycle/2);
            clock = ~clock;
        
            if($test$plusargs("TEST1"))
                begin
                    test_h = new(DUV_IF,DUV_IF,DUV_IF,DUV_IF);
                    number_of_transactions = 500;
                    test_h.build();
                    test_h.run();
                end
         end

         initial
            begin
                
                $shm_open("wave.shm");
                $shm_probe("ACTMF");

            end

endmodule
