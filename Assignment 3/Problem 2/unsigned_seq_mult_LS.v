/* Assignment No.: 3
   Problem No.: 2
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


//Module for 2X1 Multiplexer
module MUX(input sel, input i0, input i1, output Y);

assign Y = sel ? i1 : i0;

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


//Module for a 12-bit fulladder
module ripple_carry_adder(input [11:0]a, input [11:0]b, output [11:0]sum);
    wire [12:0]temp;
    genvar i;
    generate
        for(i = 0; i <= 11; i = i + 1)
            begin
                fulladder fa(.a(a[i]), .b(b[i]), .cin(temp[i]), .sum(sum[i]), .carry(temp[i+1]));
            end
    endgenerate
    assign temp[0] = 1'b0;
endmodule


//Module for register that will be used to store the multiplicand a
module register_a(input [5:0]a, input clk, input load, output [5:0]aout);
    wire [5:0]temp;
    genvar i;

    //The contents of this register will remain fixed throughout
    generate
        for(i = 0; i <= 5; i = i + 1)
            begin
                Dflipflop d(.clk(clk), .rst(1'b0), .D(temp[i]), .Q(aout[i]));
                MUX mux(.sel(load), .i0(aout[i]), .i1(a[i]), .Y(temp[i]));
            end
    endgenerate
endmodule


//Module for register that will be used to store the multiplier b
module register_b(input [5:0]b, input clk, input rst, input load, output bout);
    wire [5:0]temp;
    wire [6:0]temp1;
    genvar i;

    //The contents of this register will be left shifted by 1 bit in each clock cycle
    generate
        for(i = 0; i <= 5; i = i + 1)
            begin
                Dflipflop d(.clk(clk), .rst(rst), .D(temp[i]), .Q(temp1[i+1]));
                MUX mux(.sel(load), .i0(temp1[i]), .i1(b[i]), .Y(temp[i]));
            end
    endgenerate

    assign temp1[0] = 1'b0;
    assign bout = temp1[6];             //Outputs the MSB in each clock cycle
endmodule


//Module for register that will be used to store the product
module register_P(input [11:0]addinp, input clk, input rst, input load, output [12:0]out);
    wire [12:0]temp;
    genvar i;

    Dflipflop d0(.clk(clk), .rst(rst), .D(1'b0), .Q(out[0]));
    generate
        for(i = 1; i <= 12; i = i + 1)
            begin
                Dflipflop d(.clk(clk), .rst(rst), .D(temp[i]), .Q(out[i]));
                MUX mux(.sel(load), .i0(addinp[i-1]), .i1(1'b0), .Y(temp[i]));
            end
    endgenerate

endmodule


//Module for unsigned sequential multiplier using left shift
module unsigned_seq_mult_LS(input clk, input rst, input load, input [5:0]a, input [5:0]b, output [11:0]product);
    wire [5:0]temp1;
    wire temp;
    wire [11:0]temp2;
    wire [12:0]temp3;
    wire [5:0]temp4;
    wire [5:0]temp5;
    wire [11:0]temp6;
    genvar i;

    assign temp5 = 6'b000000;
    assign temp6 = {temp5, temp4};

    //Register to store multiplicand a
    register_a reg1(.a(a), .clk(clk), .load(load), .aout(temp1));
    
    //Register to store multiplier b
    register_b reg2(.b(b), .clk(clk), .rst(rst), .load(load), .bout(temp));
    
    //Register to store product
    register_P reg3(.addinp(temp2), .clk(clk), .rst(rst), .load(load), .out(temp3));
    
    //Adder
    ripple_carry_adder rca(.a(temp3[11:0]), .b(temp6), .sum(temp2));
    
    for(i = 0; i <= 5; i = i + 1)
        begin
            and(temp4[i], temp1[i], temp);
        end
    
    assign product = temp3[12:1];
endmodule