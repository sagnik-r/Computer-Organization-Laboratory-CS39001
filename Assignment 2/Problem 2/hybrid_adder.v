/* Assignment No.: 2 
   Problem No.: 2
   Semester: 5
   Group No.: G18
   Names: Debajyoti Kar (18CS10011), Sagnik Roy (18CS10063) */


//Module for fulladder
module fulladder2(input a, input b, input c0, output s, output p, output g);
    xor(p, a, b);                      //p = a ^ b (Carry Propagate)
    and(g, a, b);                      //g = a & b (Carry Generate)
    xor(s, a, b, c0);                  //s = a ^ b ^ c0
endmodule


//Module for a Carry Lookahead Unit
module CLA(input [3:0]p, input [3:0]g, input c0, output [4:1]c);
    genvar i;
    wire [3:0]temp;

    //c_i+1 = g_i + p_i & c_i
    and(temp[0], p[0], c0);
    or(c[1], g[0], temp[0]);
    for(i = 1; i <= 3; i = i + 1)
        begin
            and(temp[i], p[i], c[i]);
            or(c[i+1], g[i], temp[i]);
        end
    
endmodule


//Module for a Block Carry Lookahead Unit
module BCLA(input [3:0]a, input [3:0]b, input c0, output [3:0]s, output carry);
    wire [7:0]temp;
    wire [3:0]temp1;

    //It consists of 4 fulladders and a CLA unit
    //The input carry is fed to the first fulladder and the CLA unit generates the input carry for the other fulladders 
    fulladder2 fa1(.a(a[0]), .b(b[0]), .c0(c0), .s(s[0]), .p(temp[0]), .g(temp[4]));
    fulladder2 fa2(.a(a[1]), .b(b[1]), .c0(temp1[0]), .s(s[1]), .p(temp[1]), .g(temp[5]));
    fulladder2 fa3(.a(a[2]), .b(b[2]), .c0(temp1[1]), .s(s[2]), .p(temp[2]), .g(temp[6]));
    fulladder2 fa4(.a(a[3]), .b(b[3]), .c0(temp1[2]), .s(s[3]), .p(temp[3]), .g(temp[7]));
    CLA cla1(.p(temp[3:0]), .g(temp[7:4]), .c0(c0), .c(temp1));
    assign carry = temp1[3];        
endmodule


//Module for hybrid adder
module hybrid_adder(input [7:0]a, input [7:0]b, input cin, output [7:0]sum, output cout);
    wire temp;
    
    //Consists of two BCLA units each generating 4 sum bits
    BCLA bcla1(.a(a[3:0]), .b(b[3:0]), .c0(cin), .s(sum[3:0]), .carry(temp));
    //Output carry of the first unit is fed as the input carry of the second unit
    BCLA bcla2(.a(a[7:4]), .b(b[7:4]), .c0(temp), .s(sum[7:4]), .carry(cout));
endmodule




