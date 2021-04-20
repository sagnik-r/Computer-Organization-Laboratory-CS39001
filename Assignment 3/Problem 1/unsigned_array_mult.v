/* Assignment No.: 3 
   Problem No.: 1
   Semester: 5
   Group No.: G18
   Names: Debajyoti Kar (18CS10011), Sagnik Roy (18CS10063) */


//Module for halfadder
module halfadder(input a, input b, output sum, output carry);
    xor(sum, a, b);                         //sum = a ^ b
    and(carry, a, b);                       //carry = ab
endmodule


//Module for fulladder
module fulladder(input a, input b, input cin, output sum, output carry);
    wire temp1, temp2, temp3;
    xor(sum, a, b, cin);                    //sum = a ^ b ^ cin
    and(temp1, a, b);
    and(temp2, b, cin);
    and(temp3, cin, a);
    or(carry, temp1, temp2, temp3);         //carry = ab + bc + ca
endmodule


//Module for 6-bit unsigned array multiplier
module unsigned_array_mult(input [5:0]a, input [5:0]b, output [11:0]product);
    wire [4:0]temp1;
    wire [4:0]temp2;
    wire [4:0]temp3;
    wire [4:0]temp4;
    wire [4:0]temp5;
    wire [3:0]temp6;
    wire [3:0]sum1;
    wire [3:0]sum2;
    wire [3:0]sum3;
    wire [3:0]sum4;
    wire [3:0]sum5;

    //We require 6 halfadders and 24 fulladders in total
    and(product[0], a[0], b[0]);
    halfadder ha1(.a(a[0] & b[1]), .b(a[1] & b[0]), .sum(product[1]), .carry(temp1[0]));
    halfadder ha2(.a(a[2] & b[0]), .b(a[1] & b[1]), .sum(sum1[0]), .carry(temp1[1]));
    halfadder ha3(.a(a[2] & b[1]), .b(a[3] & b[0]), .sum(sum1[1]), .carry(temp1[2]));
    halfadder ha4(.a(a[3] & b[1]), .b(a[4] & b[0]), .sum(sum1[2]), .carry(temp1[3]));
    halfadder ha5(.a(a[4] & b[1]), .b(a[5] & b[0]), .sum(sum1[3]), .carry(temp1[4]));
    halfadder ha6(.a(temp5[0]), .b(sum5[0]), .sum(product[6]), .carry(temp6[0]));

    fulladder fa11(.a(a[0] & b[2]), .b(sum1[0]), .cin(temp1[0]), .sum(product[2]), .carry(temp2[0]));
    fulladder fa12(.a(a[1] & b[2]), .b(sum1[1]), .cin(temp1[1]), .sum(sum2[0]), .carry(temp2[1]));
    fulladder fa13(.a(a[2] & b[2]), .b(sum1[2]), .cin(temp1[2]), .sum(sum2[1]), .carry(temp2[2]));
    fulladder fa14(.a(a[3] & b[2]), .b(sum1[3]), .cin(temp1[3]), .sum(sum2[2]), .carry(temp2[3]));
    fulladder fa15(.a(a[4] & b[2]), .b(a[5] & b[1]), .cin(temp1[4]), .sum(sum2[3]), .carry(temp2[4]));

    fulladder fa21(.a(a[0] & b[3]), .b(sum2[0]), .cin(temp2[0]), .sum(product[3]), .carry(temp3[0]));
    fulladder fa22(.a(a[1] & b[3]), .b(sum2[1]), .cin(temp2[1]), .sum(sum3[0]), .carry(temp3[1]));
    fulladder fa23(.a(a[2] & b[3]), .b(sum2[2]), .cin(temp2[2]), .sum(sum3[1]), .carry(temp3[2]));
    fulladder fa24(.a(a[3] & b[3]), .b(sum2[3]), .cin(temp2[3]), .sum(sum3[2]), .carry(temp3[3]));
    fulladder fa25(.a(a[4] & b[3]), .b(a[5] & b[2]), .cin(temp2[4]), .sum(sum3[3]), .carry(temp3[4]));

    fulladder fa31(.a(a[0] & b[4]), .b(sum3[0]), .cin(temp3[0]), .sum(product[4]), .carry(temp4[0]));
    fulladder fa32(.a(a[1] & b[4]), .b(sum3[1]), .cin(temp3[1]), .sum(sum4[0]), .carry(temp4[1]));
    fulladder fa33(.a(a[2] & b[4]), .b(sum3[2]), .cin(temp3[2]), .sum(sum4[1]), .carry(temp4[2]));
    fulladder fa34(.a(a[3] & b[4]), .b(sum3[3]), .cin(temp3[3]), .sum(sum4[2]), .carry(temp4[3]));
    fulladder fa35(.a(a[4] & b[4]), .b(a[5] & b[3]), .cin(temp3[4]), .sum(sum4[3]), .carry(temp4[4]));

    fulladder fa41(.a(a[0] & b[5]), .b(sum4[0]), .cin(temp4[0]), .sum(product[5]), .carry(temp5[0]));
    fulladder fa42(.a(a[1] & b[5]), .b(sum4[1]), .cin(temp4[1]), .sum(sum5[0]), .carry(temp5[1]));
    fulladder fa43(.a(a[2] & b[5]), .b(sum4[2]), .cin(temp4[2]), .sum(sum5[1]), .carry(temp5[2]));
    fulladder fa44(.a(a[3] & b[5]), .b(sum4[3]), .cin(temp4[3]), .sum(sum5[2]), .carry(temp5[3]));
    fulladder fa45(.a(a[4] & b[5]), .b(a[5] & b[4]), .cin(temp4[4]), .sum(sum5[3]), .carry(temp5[4]));

    fulladder fa51(.a(temp6[0]), .b(sum5[1]), .cin(temp5[1]), .sum(product[7]), .carry(temp6[1]));
    fulladder fa52(.a(temp6[1]), .b(sum5[2]), .cin(temp5[2]), .sum(product[8]), .carry(temp6[2]));
    fulladder fa53(.a(temp6[2]), .b(sum5[3]), .cin(temp5[3]), .sum(product[9]), .carry(temp6[3]));
    fulladder fa54(.a(temp6[3]), .b(a[5] & b[5]), .cin(temp5[4]), .sum(product[10]), .carry(product[11]));

endmodule






    


