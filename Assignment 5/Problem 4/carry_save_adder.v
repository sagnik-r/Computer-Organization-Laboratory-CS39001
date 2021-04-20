/* Assignment No.: 5
   Problem No.: 4
   Semester: 5
   Group No.: G18
   Names: Debajyoti Kar (18CS10011), Sagnik Roy (18CS10063) */

//Module for 1-bit carry save adder
module CSA(input a, input b, input c, output sum, output carry);
    wire temp1, temp2, temp3;
    xor(sum, a, b, c);                          //sum = a ^ b ^ c
    and(temp1, a, b);
    and(temp2, b, c);
    and(temp3, c, a);
    or(carry, temp1, temp2, temp3);             //carry = ab + bc + ca
endmodule


//Module for a 19-bit carry save adder (19-bit input, 20-bit output)
module carry_save_unit(input [18:0]a, input [18:0]b, input [18:0]c, output [19:0]sum, output [19:0]carry);
    genvar i;
    
    generate
        for(i = 0; i <= 18; i = i + 1)
            begin

                //Instantiate 19 1-bit carry save adders
                CSA csa(.a(a[i]), .b(b[i]), .c(c[i]), .sum(sum[i]), .carry(carry[i+1]));
            end
    endgenerate

    assign carry[0] = 1'b0;
    assign sum[19] = 1'b0;
endmodule


//Module for fulladder
module fulladder(input a, input b, input cin, output sum, output p, output g);
    xor(p, a, b);                               //p = a ^ b (Carry Propagate)
    and(g, a, b);                               //g = ab (Carry Generate)
    xor(sum, a, b, cin);                        //sum = a ^ b ^ cin
endmodule


//Module for 4-bit Carry Lookahead Unit 
module CLA4(input [3:0]p, input [3:0]g, input cin, output [4:1]carry, output PG, output GG);
    wire [10:1]temp;

    and(temp[1], p[0], cin);
    or(carry[1], g[0], temp[1]);                                //Set carry[1]

    and(temp[2], p[1], p[0], cin);
    and(temp[3], p[1], g[0]);
    or(carry[2], g[1], temp[2], temp[3]);                       //Set carry[2]

    and(temp[4], p[2], p[1], p[0], cin);
    and(temp[5], p[2], p[1], g[0]);
    and(temp[6], p[2], g[1]);
    or(carry[3], g[2], temp[4], temp[5], temp[6]);              //Set carry[3]

    and(temp[7], p[3], p[2], p[1], p[0], cin);
    and(temp[8], p[3], p[2], p[1], g[0]);
    and(temp[9], p[3], p[2], g[1]);
    and(temp[10], p[3], g[2]);
    or(carry[4], g[3], temp[7], temp[8], temp[9], temp[10]);    //Set carry[4]

    and(PG, p[0], p[1], p[2], p[3]);                            //Set the Group Propagate
    or(GG, g[3], temp[8], temp[9], temp[10]);                   //Set the Group Generate
endmodule


//Module for a 4-bit Block Carry Lookahead Unit
module BCLA4(input [3:0]a, input [3:0]b, input cin, output [3:0]sum, output cout, output PG, output GG);
    wire [4:0]temp;
    wire [3:0]p;
    wire [3:0]g;
    genvar i;

    //It has 4 fulladders and a 4-bit Carry Lookahead Unit
    generate
        for(i = 0; i <= 3; i = i + 1)
            begin
                fulladder fa(.a(a[i]), .b(b[i]), .cin(temp[i]), .sum(sum[i]), .p(p[i]), .g(g[i]));
            end
    endgenerate

    CLA4 cla4(.p(p), .g(g), .cin(cin), .carry(temp[4:1]), .PG(PG), .GG(GG));
    assign temp[0] = cin;
    assign cout = temp[4];
endmodule


//Module for a 16-bit Block Carry Lookahead Unit
module BCLA16(input [15:0]a, input [15:0]b, input cin, output [15:0]sum, output cout);
    wire [4:0]temp;
    wire [3:0]p;
    wire [3:0]g;
    genvar i;
    
    generate
        for(i = 0; i <= 3; i = i + 1)
            begin

                //4 4-bit Block Carry Lookahead Units
                BCLA4 bcla4(.a(a[(4*i)+3:4*i]), .b(b[(4*i)+3:4*i]), .cin(temp[i]), .sum(sum[(4*i)+3:4*i]), .cout(), .PG(p[i]), .GG(g[i]));
            end
    endgenerate

    //Carry Lookahead Unit
    CLA4 cla4(.p(p), .g(g), .cin(cin), .carry(temp[4:1]), .PG(), .GG());
    assign temp[0] = cin;
    assign cout = temp[4];
endmodule


//Since we are adding 9 16-bit numbers, the result is <= (2^16 - 1)*9 < 2^20 - 1
//Thus the final sum will fit in 20 bits


//Module for 20-bit Carry Lookahead Adder
module CLA_final_adder(input [19:0]a, input [19:0]b, output [19:0]sum);
    wire temp;

    //We use a 16-bit BCLA for the righmost 16 bits and a 4-bit BCLA for the leftmost 4 bits
    BCLA16 bcla16(.a(a[15:0]), .b(b[15:0]), .cin(1'b0), .sum(sum[15:0]), .cout(temp));
    BCLA4 bcla4(.a(a[19:16]), .b(b[19:16]), .cin(temp), .sum(sum[19:16]), .cout(), .PG(), .GG());
endmodule


//Module for Carry Save Adder
module carry_save_adder(input [15:0]a0, input [15:0]a1, input [15:0]a2, input [15:0]a3, input [15:0]a4, input [15:0]a5, input [15:0]a6, input [15:0]a7, input [15:0]a8, output [19:0]sum);
    wire [2:0]temp;
    assign temp = 3'b000;
    wire [18:0]temp0;
    wire [18:0]temp1;
    wire [18:0]temp2;
    wire [18:0]temp3;
    wire [18:0]temp4;
    wire [18:0]temp5;
    wire [18:0]temp6;
    wire [18:0]temp7;
    wire [18:0]temp8;

    wire [19:0]temp9;
    wire [19:0]temp10;
    wire [19:0]temp11;
    wire [19:0]temp12;
    wire [19:0]temp13;
    wire [19:0]temp14;
    wire [19:0]temp15;
    wire [19:0]temp16;
    wire [19:0]temp17;
    wire [19:0]temp18;
    wire [19:0]temp19;
    wire [19:0]temp20;
    wire [19:0]temp21;
    wire [19:0]temp22;

    assign temp0 = {temp, a0};
    assign temp1 = {temp, a1};
    assign temp2 = {temp, a2};
    assign temp3 = {temp, a3};
    assign temp4 = {temp, a4};
    assign temp5 = {temp, a5};
    assign temp6 = {temp, a6};
    assign temp7 = {temp, a7};
    assign temp8 = {temp, a8};

    //We build the carry save adder in the form of the Wallace tree, so we require 7 carry save units
    carry_save_unit csu1(.a(temp0), .b(temp1), .c(temp2), .sum(temp9), .carry(temp10));    
    carry_save_unit csu2(.a(temp3), .b(temp4), .c(temp5), .sum(temp11), .carry(temp12));
    carry_save_unit csu3(.a(temp6), .b(temp7), .c(temp8), .sum(temp13), .carry(temp14));
    carry_save_unit csu4(.a(temp9[18:0]), .b(temp10[18:0]), .c(temp11[18:0]), .sum(temp15), .carry(temp16));
    carry_save_unit csu5(.a(temp12[18:0]), .b(temp13[18:0]), .c(temp14[18:0]), .sum(temp17), .carry(temp20));
    carry_save_unit csu6(.a(temp15[18:0]), .b(temp16[18:0]), .c(temp17[18:0]), .sum(temp18), .carry(temp19));
    carry_save_unit csu7(.a(temp18[18:0]), .b(temp19[18:0]), .c(temp20[18:0]), .sum(temp21), .carry(temp22));

    //Final CLA adder for the last stage
    CLA_final_adder lca(.a(temp21), .b(temp22), .sum(sum));
endmodule