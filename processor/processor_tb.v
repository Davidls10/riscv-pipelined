`include "processor.v"

module processor_tb;
    wire pc_out, alu_result;
    reg clk, reset;

    processor pc1(.pc_out(pc_out), .alu_result(alu_result),
                  .clk(clk), .reset(reset)); 

    initial begin
        reset = 1;
        clk = 1'b0;
        #5 reset = 0;
        #5 clk = ~clk;
        #5 clk = ~clk;
        #5 clk = ~clk;
        #5 clk = ~clk;
        #5 clk = ~clk;
        #5 clk = ~clk;
        #5 clk = ~clk;
        #5 clk = ~clk;
        #5 clk = ~clk;
        #5 clk = ~clk;
        #5 clk = ~clk;
        #5 clk = ~clk;
        #5 clk = ~clk;
        #5 clk = ~clk;
        #5 clk = ~clk;
        #5 clk = ~clk;
        #5 clk = ~clk;
        #5 clk = ~clk;
        #5 clk = ~clk;
        #5 clk = ~clk;
        #5 clk = ~clk;
        #5 clk = ~clk;
        #5 clk = ~clk;
        #5 clk = ~clk;
        #5 clk = ~clk;
        #5 clk = ~clk;
        #5 clk = ~clk;
        #5 clk = ~clk;
        #5 clk = ~clk;
    end
    
endmodule