module hazard_unit (output reg [2-1:0] ForwardAE, 
                    output reg [2-1:0] ForwardBE,
                    input [5-1:0] RegSource1E, 
                    input [5-1:0] RegSource2E,
                    input [5-1:0] RegDestinM,
                    input [5-1:0] RegDestinW,
                    input RegWriteM,
                    input RegWriteW);

    always @* begin
        if (((RegSource1E == RegDestinM) & RegWriteM) & (RegSource1E != 1'b0))
            ForwardAE = 2'b10;
        else if (((RegSource2E == RegDestinM) & RegWriteM) & (RegSource2E != 1'b0))
            ForwardBE = 2'b10;
        else if (((RegSource1E == RegDestinW) & RegWriteW) & (RegSource1E != 1'b0))
            ForwardAE = 2'b01;
        else if (((RegSource2E == RegDestinW) & RegWriteW) & (RegSource2E != 1'b0))
            ForwardBE = 2'b01;
        else begin
            ForwardAE = 2'b00;
            ForwardBE = 2'b00;
        end
    end
endmodule