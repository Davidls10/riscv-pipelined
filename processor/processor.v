module pipelined_processor;
    // fetch stage datapath signals
    reg [31:0] PCF;
    wire [31:0] nextPCF, PCPlus4F;

    // decode stage datapath signals
    reg [31:0] InstrD, PCD, ImmExtD, PCPlus4D;
    reg [4:0] RdD;

    // execute stage datapath signals
    reg [31:0] RD1E, RD2E, PCE, ImmExtE, PCPlus4E, SrcAE, SrcBE, WriteDataE, PCTargetE;
    reg [4:0] RdE;
    wire ZeroE;

    // memory stage datapath signals
    reg [31:0] ALUResultM, WriteDataM, PCPlus4M;
    reg [4:0] RdM;

    // writeback stage datapath signals
    reg [31:0] ReadDataW, PCPlus4W;
    reg [4:0] RdW;
    wire [31:0] ResultW;

    // decode stage control signals
    wire RegWriteD, MemWriteD, JumpD, BranchD, AluSrcD;
    wire [2:0] ALUControlD;
    wire [1:0] ResultSrcD, ImmSrcD;

    // execute stage control signals
    reg RegWriteE, MemWriteE, JumpE, BranchE, AluSrcE;
    reg [2:0] ALUControlE;
    reg [1:0] ResultSrcE;

    // memory stage control signals
    reg RegWriteM, MemWriteM;
    reg [1:0] ResultSrcM;

    // writeback stage control signals
    reg RegWriteW;
    reg [1:0] ResultSrcW;

    
endmodule