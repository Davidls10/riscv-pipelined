`include "instruction_memory.v"
`include "control_unit.v"
`include "extend.v"
`include "register_file.v"
`include "alu.v"
`include "data_memory.v"
`include "hazard_unit.v"

module processor(output pc_out, alu_result,
                 input clk, reset
                );

    // fetch stage datapath signals
    reg [31:0] PCF;
    wire [31:0] PCFNext, PCPlus4F;
    wire [31:0] InstrF;

    // decode stage datapath signals
    reg [31:0] InstrD, PCD, PCPlus4D;
    wire [31:0] ImmExtD, RD1D, RD2D;
    wire [4:0] RdD;

    // execute stage datapath signals
    reg [31:0] RD1E, RD2E, PCE, ImmExtE, PCPlus4E;
    wire [31:0] SrcAE, SrcBE;
    reg [4:0] RdE;
    wire ZeroE, PCSrcE;
    wire [31:0] ALUResultE, PCTargetE, WriteDataE;

    // memory stage datapath signals
    reg [31:0] ALUResultM, WriteDataM, PCPlus4M;
    reg [4:0] RdM;
    wire [31:0] ReadDataM;

    // writeback stage datapath signals
    reg [31:0] ALUResultW, ReadDataW, PCPlus4W;
    reg [4:0] RdW;
    wire [31:0] ResultW;

    // decode stage control signals
    wire RegWriteD, MemWriteD, JumpD, BranchD, AluSrcD;
    wire [1:0] ALUOpD;
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

    // hazard unit signals
    wire [5-1:0] Rs1D, Rs2D;
    reg [5-1:0] Rs1E, Rs2E;
    wire [1:0] ForwardAE, ForwardBE;


    always @(posedge clk or posedge reset) begin
        // display datapath fetch signals
        $display($time, " PCFNext = %x  PCF = %x  PCPlus4F = %x  InstrF = %b PCSrcE = %b", PCFNext, PCF, PCPlus4F, InstrF, PCSrcE);

        if (reset) begin
            PCF <= 32'd0;
            InstrD <= 32'd0;

            
            // decode stage datapath signals update
            InstrD <= 32'd0;
            PCD <= 32'd0;
            PCPlus4D <= 32'd0;

            // execute stage datapath signals update
            RD1E <= 0;
            RD2E <= 0;
            RdE <= 0;
            PCE <= 0;
            Rs1E <= 0;
            Rs2E <= 0;

            // memory stage datapath signals update
            ALUResultM <= 0;
            WriteDataM <= 0;
            RdM <= 0;
            PCPlus4M <= 0;

            // writeback stage datapath signals update
            ALUResultW <= 0;
            ReadDataW <= 0;
            RdW <= 0;
            PCPlus4W <= 0;

            // execute stage control signals update
            RegWriteE <= 0;
            ResultSrcE <= 0;
            MemWriteE <= 0;
            JumpE <= 0;
            BranchE <= 0;
            ALUControlE <= 0;
            AluSrcE <= 0;

            // memory stage control signals update
            RegWriteM <= 0;
            ResultSrcM <= 0;
            MemWriteM <= 0;

            // writeback stage control signals
            RegWriteW <= 0;
            ResultSrcW <= 0;
        end
        else begin
            // writeback stage control signals
            RegWriteW <= RegWriteM;
            ResultSrcW <= ResultSrcM;

            // memory stage control signals update
            RegWriteM <= RegWriteE;
            ResultSrcM <= ResultSrcE;
            MemWriteM <= MemWriteE;

            // execute stage control signals update
            RegWriteE <= RegWriteD;
            ResultSrcE <= ResultSrcD;
            MemWriteE <= MemWriteD;
            JumpE <= JumpD;
            BranchE <= BranchD;
            ALUControlE <= ALUControlD;
            AluSrcE <= AluSrcD;

            // writeback stage datapath signals update
            ALUResultW <= ALUResultM;
            ReadDataW <= ReadDataM;
            RdW <= RdM;
            PCPlus4W <= PCPlus4M;

            // memory stage datapath signals update
            ALUResultM <= ALUResultE;
            WriteDataM <= WriteDataE;
            RdM <= RdE;
            PCPlus4M <= PCPlus4E;

            // execute stage datapath signals update
            RD1E <= RD1D;
            RD2E <= RD2D;
            RdE <= RdD;
            ImmExtE <= ImmExtD;
            PCE <= PCD;
            PCPlus4E <= PCPlus4D;
            Rs1E <= Rs1D;
            Rs2E <= Rs2D;

            // decode stage datapath signals update
            InstrD <= InstrF;
            PCD <= PCF;
            PCPlus4D <= PCPlus4F;

            PCF <= PCFNext;
        end

        $display("PCD = %x  InstrD = %b  A1 = %d  A2 = %d  JumpD = %d  BranchD = %d  RegWriteD = %b", 
                 PCD, InstrD, InstrD[19:15], InstrD[24:20], JumpD, BranchD, RegWriteD);
        $display("RD1D = %d  RD2D = %d  ImmExtD = %x  PCPlus4D = %x", RD1D, RD2D, ImmExtD, PCPlus4D);
        $display("RD1E = %d  RD2E = %d", RD1E, RD2E);
        $display("BranchE = %d  ZeroE = %d  AluSrcD = %d  JumpE = %d", BranchE, ZeroE, AluSrcD, JumpE);
        $display("PCE = %x  ImmExtE = %x  ALUResultE = %x  RegWriteE = %b  PCPlus4E = %x", PCE, ImmExtE, ALUResultE, RegWriteE, PCPlus4E);
        $display("ALUResultM = %d  WriteDataM = %b  RdM = %d  PCPlus4M = %d  RegWriteM = %d", ALUResultM, WriteDataM, RdM, PCPlus4M, RegWriteM);
        $display("RegWriteW = %b  ResultSrcW = %d  ALUResultW = %d  ReadDataW = %d  PCPlus4W = %d  ResultW = %d  RdW = %d", 
                 RegWriteW, ResultSrcW, ALUResultW, ReadDataW, PCPlus4W, ResultW, RdW);
        $display("ForwardAE = %b  ForwardBE = %b  SrcAE = %d  SrcBE = %d\n\n", ForwardAE, ForwardBE, SrcAE, SrcBE);
    end

    // program counter + 4
    assign PCPlus4F = PCF + 32'd4;


    // instruction memory
    /**
    * The instruction memory contains the instructions of the program that will run.
    */
    instruction_memory instr_mem(.pc(PCF), .instr(InstrF));


    // control unit
    /**
    * The control unit aims to control the signals of the computer to achieve a result
    * based on the current instruction. The control unit is the union of the main 
    * decoder and the alu decoder units.
    */

    main_decoder main_dec(.opcode(InstrD[6:0]), .reg_write(RegWriteD), 
                          .imm_src(ImmSrcD), .alu_src(AluSrcD), 
                          .mem_write(MemWriteD), .result_src(ResultSrcD[1:0]), 
                          .branch(BranchD), .alu_op(ALUOpD), .jump(JumpD));

    alu_decoder alu_dec(.alu_control(ALUControlD[2:0]),
                        .alu_op(ALUOpD),
                        .funct3(InstrD[14:12]),
                        .op5(InstrD[5]),
                        .funct7_5(InstrD[30]));


    // extend unit
    /**
    * The extend unit extends the signal of a number or add zeros to it.
    */

    extend ext(.imm_ext(ImmExtD), .imm_src(ImmSrcD), .instr(InstrD[31:7]));

    assign PCTargetE = PCE + ImmExtE;


    // operations on register file
    /**
    * The register file contains the registers of the processor;
    * it needs a clock, a write enable signal, the address from which
    * read data and where write data when enabled.
    */
    register_file reg_file(.clk(clk), .we(RegWriteW),
                           .a1(InstrD[19:15]), .a2(InstrD[24:20]), 
                           .a3(RdW), .wd3(ResultW),
                           .rd1(RD1D), .rd2(RD2D));

    assign RdD = InstrD[11:7];


    // ALU
    /**
    * The ALU is the part of the computer that do arithmetic and logic operations.
    */
    assign SrcAE = (ForwardAE[1] === 1) ? ALUResultM : (ForwardAE[0] === 1 ? ResultSrcW : RD1E);
    assign SrcBE = (AluSrcE === 0) ? 
                   ((ForwardBE[1] === 1) ? ALUResultM : (ForwardBE[0] === 1 ? ResultSrcW : RD2E)) :
                   ImmExtE;

    alu alu1 (.ALUResult(ALUResultE), .zero_flag(ZeroE), .SrcA(SrcAE),
              .SrcB(SrcBE), .ALUControl(ALUControlE));


    assign WriteDataE = RD2E;


    // If there is a condition to branch, the next PC value must be to the
    // instruction memory address appointed by the branching instruction.
    assign PCSrcE = (JumpE == 1'b1) ? 1'b1 : ((ZeroE == 1'b1 && BranchE == 1'b1) ? 1'b1 : 1'b0);
    assign PCTargetE = PCE + ImmExtE;
    assign PCFNext = (PCSrcE !== 1'b1) ? PCPlus4F : PCTargetE;


    // Data Memory
    /**
    * This is the main memory of the computer.
    */
    data_memory data_mem (.clk(clk), .write_enable(MemWriteM),
                          .adr(ALUResultM), .din(WriteDataM), .dout(ReadDataM));

    assign ResultW = (ResultSrcW[1] == 1'b1) ? PCPlus4W : (ResultSrcW[0] == 1'b0 ? ALUResultW : ReadDataW);


    assign Rs1D = InstrD[19:15];
    assign Rs2D = InstrD[24:20];
    hazard_unit haz_unit (.ForwardAE(ForwardAE),
                          .ForwardBE(ForwardBE),
                          .RegSource1E(Rs1E),
                          .RegSource2E(Rs2E),
                          .RegDestinM(RdM),
                          .RegDestinW(RdW),
                          .RegWriteM(RegWriteM),
                          .RegWriteW(RegWriteW));


endmodule