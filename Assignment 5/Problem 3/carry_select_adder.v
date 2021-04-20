/* Assignment No.: 5
   Problem No.: 3
   Semester: 5
   Group No.: G18
   Names: Debajyoti Kar (18CS10011), Sagnik Roy (18CS10063) */

//Module for fulladder
module fulladder(input a, input b, input cin, output sum, output carry);
    wire temp1, temp2, temp3;
    xor(sum, a, b, cin);                         //sum = a ^ b ^ c
    and(temp1, a, b);
    and(temp2, b, cin);
    and(temp3, cin, a);
    or(carry, temp1, temp2, temp3);              //carry = ab + bc + ca
endmodule


//Module for 4-bit ripple carry adder
module ripple_carry_adder(input [3:0]a, input [3:0]b, input cin, output [3:0]sum, output cout);
    wire [4:0]temp;
    genvar i;
    generate
        for(i = 0; i <= 3; i = i + 1)
            begin
                fulladder fa(.a(a[i]), .b(b[i]), .cin(temp[i]), .sum(sum[i]), .carry(temp[i+1]));
            end
    endgenerate
    assign temp[0] = cin;
    assign cout = temp[4];
endmodule


//Module for 2X1 Multiplexer
module MUX(input sel, input i0, input i1, output Y);
    assign Y = sel ? i1 : i0;
endmodule


//Module for the building block of the carry select adder
module carry_select_unit(input [3:0]a, input [3:0]b, input cin, output [3:0]sum, output cout);
    wire [3:0]sum1;
    wire [3:0]sum2;
    wire cout1;
    wire cout2;
    genvar i;

    //There are 2 4-bit ripple carry adders, one producing the sum with input carry 0 and the other with input carry 1
    ripple_carry_adder rca1(.a(a), .b(b), .cin(1'b0), .sum(sum1), .cout(cout1));
    ripple_carry_adder rca2(.a(a), .b(b), .cin(1'b1), .sum(sum2), .cout(cout2));
    generate
        for(i = 0; i <= 3; i = i + 1)
            begin
                //Multiplexers to select the desired sum based on the actual input carry to the unit
                MUX mux(.sel(cin), .i0(sum1[i]), .i1(sum2[i]), .Y(sum[i]));
            end
    endgenerate

    //Multiplexer to generate the output carry of the unit
    MUX mux1(.sel(cin), .i0(cout1), .i1(cout2), .Y(cout));
endmodule


//Module for carry select adder
module carry_select_adder(input [15:0]a, input [15:0]b, input cin, output [15:0]sum, output cout);
    wire temp1, temp2, temp3;

    //For the lowermost 4 bits, one ripple carry adder is sufficient
    ripple_carry_adder rca(.a(a[3:0]), .b(b[3:0]), .cin(cin), .sum(sum[3:0]), .cout(temp1));
    
    //For the higher 12 bits, we need 3 carry select units, each generating 4 bits of the sum
    carry_select_unit csa1(.a(a[7:4]), .b(b[7:4]), .cin(temp1), .sum(sum[7:4]), .cout(temp2));
    carry_select_unit csa2(.a(a[11:8]), .b(b[11:8]), .cin(temp2), .sum(sum[11:8]), .cout(temp3));
    carry_select_unit csa3(.a(a[15:12]), .b(b[15:12]), .cin(temp3), .sum(sum[15:12]), .cout(cout));
endmodule