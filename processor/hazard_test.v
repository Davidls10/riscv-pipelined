`include "hazard_unit.v"

module hazard_test;
    wire [2-1:0] ForwardAE, ForwardBE;
    reg [5-1:0] RegSource1E, RegSource2E, RegDestinM, RegDestinW;
    reg RegWriteM, RegWriteW;

    hazard_unit uut(.ForwardAE(ForwardAE), .ForwardBE(ForwardBE),
                    .RegSource1E(RegSource1E), .RegSource2E(RegSource2E),
                    .RegDestinM(RegDestinM), .RegDestinW(RegDestinW),
                    .RegWriteM(RegWriteM), .RegWriteW(RegWriteW)); 

    initial begin
        $dumpfile("file.vcd");
        $dumpvars(0, hazard_test);

        RegSource1E = 5; RegSource2E = 2; RegDestinM = 5; RegDestinW = 2; RegWriteM = 1; RegWriteW = 1;
        #5 if (ForwardAE !== 2'b10 && ForwardBE !== 2'b01) 
        $display ("hu failed!");

        RegSource1E = 5; RegSource2E = 2; RegDestinM = 2; RegDestinW = 5; RegWriteM = 1; RegWriteW = 1;
        #5 if (ForwardAE !== 2'b01 && ForwardBE !== 2'b10) 
        $display ("hu failed!");

        RegSource1E = 0; RegSource2E = 2; RegDestinM = 0; RegDestinW = 5; RegWriteM = 2; RegWriteW = 0;
        #5 if (ForwardAE !== 2'b00 && ForwardBE !== 2'b00)
        $display ("hu failed!");

        #5 $finish;
    end

endmodule