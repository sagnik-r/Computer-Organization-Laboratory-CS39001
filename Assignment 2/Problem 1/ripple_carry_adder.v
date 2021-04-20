/* Assignment No.: 2 
   Problem No.: 1
   Semester: 5
   Group No.: G18
   Names: Debajyoti Kar (18CS10011), Sagnik Roy (18CS10063) */


//Module for a fulladder 
module fulladder1(input a, input b, input cin, output sum, output carry);
    wire temp1, temp2, temp3;
    xor(sum, a, b, cin);                         //sum = a ^ b ^ c
    and(temp1, a, b);
    and(temp2, b, cin);
    and(temp3, cin, a);
    or(carry, temp1, temp2, temp3);              //carry = ab + bc + ca
endmodule    


//Module for ripple carry adder 
module ripple_carry_adder(input [7:0]a, input [7:0]b, input cin, output [7:0]sum, output cout);
    wire temp0, temp1, temp2, temp3, temp4, temp5, temp6;
    
    //We need 8 fulladders for the 8 bits of the sum 
    fulladder1 fa1(.a(a[0]), .b(b[0]), .cin(cin), .sum(sum[0]), .carry(temp0));
    fulladder1 fa2(.a(a[1]), .b(b[1]), .cin(temp0), .sum(sum[1]), .carry(temp1));
    fulladder1 fa3(.a(a[2]), .b(b[2]), .cin(temp1), .sum(sum[2]), .carry(temp2));
    fulladder1 fa4(.a(a[3]), .b(b[3]), .cin(temp2), .sum(sum[3]), .carry(temp3));
    fulladder1 fa5(.a(a[4]), .b(b[4]), .cin(temp3), .sum(sum[4]), .carry(temp4));
    fulladder1 fa6(.a(a[5]), .b(b[5]), .cin(temp4), .sum(sum[5]), .carry(temp5));
    fulladder1 fa7(.a(a[6]), .b(b[6]), .cin(temp5), .sum(sum[6]), .carry(temp6));
    fulladder1 fa8(.a(a[7]), .b(b[7]), .cin(temp6), .sum(sum[7]), .carry(cout));
    //The last fulladder will generate the final carry of the sum (cout)
    
endmodule