module alu (output [31:0] f, 
            output zero_flag,
            input [31:0] a, b, 
            input sel [2:0]);

    assign zero_flag = (a - b) ? 1 : 0;

    adder add1(.f(sum), .cout(cout), .a(a), .b(b)); // 000
    subtractor sub1(sub, a, b); // 001
    andN and1(y_and, a, b); // 010
    orN or1(y_or, a, b); // 011
    mux32 mux32_1(f, sum, sub, y_and, y_or, sel);
endmodule

module half_adder(s, c, a, b);
    output s, c;
    input a, b;

    assign s = a ^ b;
    assign c = a & b;
endmodule

module full_adder(s, cout, a, b, cin);
    output s, cout;
    input a, b, cin;

    half_adder h1(s1, cout1, a, b), h2(s, cout2, s1, cin);
    or g1(cout, cout1, cout2);
endmodule

module adder#(parameter N = 32)
             (output wire [N-1:0] f, 
              output wire cout,
              input wire [N-1:0] a, b);

    wire [N:0] carry;

    genvar i;

    assign carry[0] = 0;

    generate
        for (i = 0; i < N; i = i + 1) begin
            full_adder s(f[i], carry[i+1], a[i], b[i], carry[i]);
        end
    endgenerate

    assign cout = carry[N];
endmodule

module subtractor #(parameter N = 32)
                   (output wire [N-1:0] y,
                    input [N-1:0] a, b);
    
    assign y = a - b;
endmodule

module andN #(parameter N = 32)
            (output [N-1:0] f,
             input [N-1:0] a, b);

    assign f = a & b;
endmodule

module orN #(parameter N = 32)
            (output wire [N-1:0] f,
             input [N-1:0] a, b);

    assign f = a | b;
endmodule

module mux32(output [32-1:0] y,
            input [32-1:0] d0, d1, d2, d3,
            input [3-1:0] s);
        
    assign y = s[2] ? 32'bx : (s[1] ? (s[0] ? d3 : d2) : (s[0] ? d1 : d0));
endmodule