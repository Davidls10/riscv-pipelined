`include "processor.v"

module processor_tb;
    wire pc_out, alu_result;
    reg clk, reset;

    processor pc1(.pc_out(pc_out), .alu_result(alu_result),
                  .clk(clk), .reset(reset)); 


    integer i;
    
    initial begin
        reset = 1;
        clk = 1'b0;
        #5 reset = 0;

        for (i = 0; i < 50; i = i + 1) begin
            #5 clk = ~clk;
        end
    end
    
endmodule