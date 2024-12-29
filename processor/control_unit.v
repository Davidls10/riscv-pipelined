module alu_decoder (output reg [3-1:0] alu_control,
                    input [2-1:0] alu_op,
                    input [3-1:0] funct3,
                    input funct7_5,
                    input op5);

    always @* begin
        case (alu_op)
            2'b00: // lw, sw
                begin
                    alu_control = 3'b000; // add
                end
            2'b01: // beq
                begin
                    alu_control = 3'b001; // subtract
                end
            2'b10: // add
                case (funct3)
                    3'b000: // add for {op5, funct7_5} == 2'b00, 2'b01, 2'b10; subtract for {op5, funct7_5} == 2'b11
                        alu_control = ({op5, funct7_5} == 2'b00 || {op5, funct7_5} == 2'b01 || {op5, funct7_5} == 2'b10) ? 3'b000 : 3'b001;
                    3'b010:
                        alu_control = 3'b101; // set less than
                    3'b110:
                        alu_control = 3'b011; // or
                    3'b111:
                        alu_control = 3'b010; // and
                endcase
        endcase
    end
endmodule

module main_decoder (input [7-1:0] opcode,
                     output reg reg_write,
                     output reg [2-1:0] imm_src,
                     output reg alu_src,
                     output reg mem_write,
                     output reg [2-1:0] result_src,
                     output reg branch,
                     output reg [2-1:0] alu_op,
                     output reg jump
                    );

    initial begin
        reg_write = 1'b0;
        imm_src = 2'b00;
        alu_src = 1'b0;
        mem_write = 1'b0;
        result_src = 2'b00;
        branch = 1'b0;
        alu_op = 2'b00;
        jump = 1'b0;        
    end

    always @* begin
        case (opcode)
            7'b0000011: // lw
                begin
                    reg_write = 1'b1;
                    imm_src = 2'b00;
                    alu_src = 1'b1;
                    mem_write = 1'b0;
                    result_src = 2'b01;
                    branch = 1'b0;
                    alu_op = 2'b00;
                    jump = 1'b0;
                end
            7'b0100011: // sw
                begin
                    reg_write = 1'b0;
                    imm_src = 2'b01;
                    alu_src = 1'b1;
                    mem_write = 1'b1;
                    result_src = 2'bXX;
                    branch = 1'b0;
                    alu_op = 2'b00;
                    jump = 1'b0;
                end
            7'b0110011: // R-type or
                begin
                    reg_write = 1'b1;
                    imm_src = 2'bXX;
                    alu_src = 1'b0;
                    mem_write = 1'b0;
                    result_src = 2'b00;
                    branch = 1'b0;
                    alu_op = 2'b10;
                    jump = 1'b0;
                end
            7'b0110011: // R-type and
                begin
                    reg_write = 1'b1;
                    imm_src = 2'bXX;
                    alu_src = 1'b0;
                    mem_write = 1'b0;
                    result_src = 2'b00;
                    branch = 1'b0;
                    alu_op = 2'b10;
                    jump = 1'b0;
                end
            7'b1100011: // beq
                begin
                    reg_write = 1'b0;
                    imm_src = 2'b10;
                    alu_src = 1'b0;
                    mem_write = 1'b0;
                    result_src = 2'bXX;
                    branch = 1'b1;
                    alu_op = 2'b01;
                    jump = 1'b0;
                end
            7'b0010011: // addi
                begin
                    reg_write = 1'b1;
                    imm_src = 2'b00;
                    alu_src = 1'b1;
                    mem_write = 1'b0;
                    result_src = 2'b00;
                    branch = 1'b0;
                    alu_op = 2'b10;
                    jump = 1'b0;
                end
            7'b1101111: // jal
                begin
                    reg_write = 1'b1;
                    imm_src = 2'b00;
                    alu_src = 1'b1;
                    mem_write = 1'b0;
                    result_src = 2'b10;
                    branch = 1'b0;
                    alu_op = 2'bXX;
                    jump = 1'b1;
                end

            default:
                begin
                    reg_write = 1'bx;
                    imm_src = 2'bxx;
                    alu_src = 1'bx;
                    mem_write = 1'bx;
                    result_src = 2'bxx;
                    branch = 1'bx;
                    alu_op = 2'bxx;
                    jump = 1'bx;                        
                    // reg_write = 1'b0;
                    // imm_src = 2'b00;
                    // alu_src = 1'b0;
                    // mem_write = 1'b0;
                    // result_src = 2'b00;
                    // branch = 1'b0;
                    // alu_op = 2'b00;
                    // jump = 1'b0;        
                end
        endcase
    end

endmodule