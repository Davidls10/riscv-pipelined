module hazard_unit (output reg [2-1:0] ForwardAE,
                    output reg [2-1:0] ForwardBE,
                    output wire lwStall,
                    output wire StallF,
                    output wire StallD,
                    output wire FlushD,
                    output wire FlushE,
                    input [5-1:0] Rs1D,
                    input [5-1:0] Rs2D,
                    input [5-1:0] Rs1E,
                    input [5-1:0] Rs2E,
                    input [5-1:0] RdE,
                    input [5-1:0] RdM,
                    input [5-1:0] RdW,
                    input RegWriteM,
                    input RegWriteW,
                    input PCSrcE,
                    input ResultSrcE0);

    always @* begin
        // Forward logic
        if (((Rs1E == RdM) & RegWriteM) & (Rs1E != 1'b0))
            ForwardAE <= 2'b10;
        else if (((Rs1E == RdW) & RegWriteW) & (Rs1E != 1'b0))
            ForwardAE <= 2'b01;
        else 
            ForwardAE <= 2'b00;

        if (((Rs2E == RdM) & RegWriteM) & (Rs2E != 1'b0))
            ForwardBE <= 2'b10;
        else if (((Rs2E == RdW) & RegWriteW) & (Rs2E != 1'b0))
            ForwardBE <= 2'b01;
        else
            ForwardBE <= 2'b00;

    end

    // Stall logic
    assign lwStall = ResultSrcE0 & ((Rs1D == RdE) || (Rs2D == RdE)); // if ResultSrcE[0] == 1, load word is in the Execute stage
    assign StallD = lwStall;
    assign StallF = lwStall;

    // Flush logic
    assign FlushD = PCSrcE;
    assign FlushE = lwStall | PCSrcE;

endmodule