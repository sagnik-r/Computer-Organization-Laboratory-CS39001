/* Assignment No.: 3
   Problem No.: 3
   Semester: 5
   Group No.: G18
   Names: Debajyoti Kar (18CS10011), Sagnik Roy (18CS10063) */

//Module for D flipflop
module Dflipflop(input clk, input rst, input D, output Q);
    reg Q;
    always @(posedge clk or posedge rst)
    begin
        if(rst)
            Q <= Q;                 //if rst = 1, output remains unchanged
        else
            Q <= D;                 //if rst = 0, output = input (at positive edge of clock)
    end
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


//Module for 6-bit ripple carry adder
module ripple_carry_adder(input [5:0]a, input [5:0]b, input cin, output [5:0]sum, output cout);
    wire temp0, temp1, temp2, temp3, temp4;
    
    //We need 6 fulladders for the 6 bits of the sum 
    fulladder fa1(.a(a[0]), .b(b[0]), .cin(cin), .sum(sum[0]), .carry(temp0));
    fulladder fa2(.a(a[1]), .b(b[1]), .cin(temp0), .sum(sum[1]), .carry(temp1));
    fulladder fa3(.a(a[2]), .b(b[2]), .cin(temp1), .sum(sum[2]), .carry(temp2));
    fulladder fa4(.a(a[3]), .b(b[3]), .cin(temp2), .sum(sum[3]), .carry(temp3));
    fulladder fa5(.a(a[4]), .b(b[4]), .cin(temp3), .sum(sum[4]), .carry(temp4));
    fulladder fa6(.a(a[5]), .b(b[5]), .cin(temp4), .sum(sum[5]), .carry(cout));
    //The last fulladder will generate the final carry of the sum (cout)
endmodule


//Module for a 2X1 Multiplexer
module MUX(input sel, input i0, input i1, output Y);

assign Y = sel ? i1 : i0;                   //if sel = 1, then output = i1, else output = i0

endmodule


//Module for register that will be used for storing multiplicand a
module register_a(input [5:0]a, input clk, input load, output [5:0]aout);
    wire [5:0]temp;
    wire [5:0]temp1;

    //We need 6 D flipflops corresponding to the 6 bits of the input
    Dflipflop d0(.clk(clk), .rst(1'b0), .D(temp[0]), .Q(temp1[0]));
    Dflipflop d1(.clk(clk), .rst(1'b0), .D(temp[1]), .Q(temp1[1]));
    Dflipflop d2(.clk(clk), .rst(1'b0), .D(temp[2]), .Q(temp1[2]));
    Dflipflop d3(.clk(clk), .rst(1'b0), .D(temp[3]), .Q(temp1[3]));
    Dflipflop d4(.clk(clk), .rst(1'b0), .D(temp[4]), .Q(temp1[4]));
    Dflipflop d5(.clk(clk), .rst(1'b0), .D(temp[5]), .Q(temp1[5]));

    MUX mux0(.sel(load), .i0(temp1[0]), .i1(a[0]), .Y(temp[0]));
    MUX mux1(.sel(load), .i0(temp1[1]), .i1(a[1]), .Y(temp[1]));
    MUX mux2(.sel(load), .i0(temp1[2]), .i1(a[2]), .Y(temp[2]));
    MUX mux3(.sel(load), .i0(temp1[3]), .i1(a[3]), .Y(temp[3]));
    MUX mux4(.sel(load), .i0(temp1[4]), .i1(a[4]), .Y(temp[4]));
    MUX mux5(.sel(load), .i0(temp1[5]), .i1(a[5]), .Y(temp[5]));

    assign aout = temp1;                   //Outputs the current state of the register
endmodule


//Module for register that will be used for storing multiplier b
module register_b(input [5:0]b, input clk, input rst, input load, input cin, output [5:0]bout);
    wire [5:0]temp;
    wire [5:0]temp1;

    //We need 6 D flipflops corresponding to the 6 bits of the input
    Dflipflop d0(.clk(clk), .rst(rst), .D(temp[0]), .Q(temp1[0]));
    Dflipflop d1(.clk(clk), .rst(rst), .D(temp[1]), .Q(temp1[1]));
    Dflipflop d2(.clk(clk), .rst(rst), .D(temp[2]), .Q(temp1[2]));
    Dflipflop d3(.clk(clk), .rst(rst), .D(temp[3]), .Q(temp1[3]));
    Dflipflop d4(.clk(clk), .rst(rst), .D(temp[4]), .Q(temp1[4]));
    Dflipflop d5(.clk(clk), .rst(rst), .D(temp[5]), .Q(temp1[5]));

    MUX mux0(.sel(load), .i0(temp1[1]), .i1(b[0]), .Y(temp[0]));
    MUX mux1(.sel(load), .i0(temp1[2]), .i1(b[1]), .Y(temp[1]));
    MUX mux2(.sel(load), .i0(temp1[3]), .i1(b[2]), .Y(temp[2]));
    MUX mux3(.sel(load), .i0(temp1[4]), .i1(b[3]), .Y(temp[3]));
    MUX mux4(.sel(load), .i0(temp1[5]), .i1(b[4]), .Y(temp[4]));
    MUX mux5(.sel(load), .i0(cin), .i1(b[5]), .Y(temp[5]));

    assign bout = temp1;                //Outputs the current state of the register
endmodule


//Module for register that will be used for storing the left 6 bits of the product
module register_A(input [5:0]addinp, input clk, input rst, input load, output [5:0]Aout);
    wire [5:0]temp;

    //We need 6 D flipflops corresponding to the 6 bits
    Dflipflop d0(.clk(clk), .rst(rst), .D(temp[0]), .Q(Aout[0]));
    Dflipflop d1(.clk(clk), .rst(rst), .D(temp[1]), .Q(Aout[1]));
    Dflipflop d2(.clk(clk), .rst(rst), .D(temp[2]), .Q(Aout[2]));
    Dflipflop d3(.clk(clk), .rst(rst), .D(temp[3]), .Q(Aout[3]));
    Dflipflop d4(.clk(clk), .rst(rst), .D(temp[4]), .Q(Aout[4]));
    Dflipflop d5(.clk(clk), .rst(rst), .D(temp[5]), .Q(Aout[5]));

    MUX mux0(.sel(load), .i0(addinp[0]), .i1(1'b0), .Y(temp[0]));
    MUX mux1(.sel(load), .i0(addinp[1]), .i1(1'b0), .Y(temp[1]));
    MUX mux2(.sel(load), .i0(addinp[2]), .i1(1'b0), .Y(temp[2]));
    MUX mux3(.sel(load), .i0(addinp[3]), .i1(1'b0), .Y(temp[3]));
    MUX mux4(.sel(load), .i0(addinp[4]), .i1(1'b0), .Y(temp[4]));
    MUX mux5(.sel(load), .i0(addinp[5]), .i1(1'b0), .Y(temp[5]));
endmodule


//Module for unsigned sequential multiplier using right shift 
module unsigned_seq_mult_RS(input clk, input rst, input load, input [5:0]a, input [5:0]b, output [11:0]product);
    wire [5:0]temp1;
    wire [5:0]temp2;
    wire [5:0]temp3;
    wire [5:0]temp4;
    wire [4:0]temp5;
    wire [5:0]temp6;
    wire [5:0]sum1;
    wire sum2;
    genvar i;

    assign temp5 = sum1[5:1];
    assign temp6 = {sum2, temp5};

    //Register for storing multiplicand a
    register_a reg1(.a(a), .clk(clk), .load(load), .aout(temp1));    
    
    //Register for storing multiplier b
    register_b reg2(.b(b), .clk(clk), .rst(rst), .load(load), .cin(sum1[0]), .bout(temp2));
    
    //Register for storing left 6 bits of product
    register_A reg3(.addinp(temp6), .clk(clk), .rst(rst), .load(load), .Aout(temp3));
    
    //Adder
    ripple_carry_adder rca(.a(temp3), .b(temp4), .cin(1'b0), .sum(sum1), .cout(sum2));

    for(i = 0; i <= 5; i = i + 1)
        and(temp4[i], temp1[i], temp2[0]);

    //The left 6 bits of the product will be finally present in reg3 and the right 6 bits will be present in reg2 (which initially contained b)
    assign product = {temp3, temp2};

endmodule
