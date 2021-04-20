/* Assignment No.: 2 
   Problem No.: 3
   Semester: 5
   Group No.: G18
   Names: Debajyoti Kar (18CS10011), Sagnik Roy (18CS10063) */


//Module for D flipflop
module DFF(input clk, input rst, input D, output Q);
    reg Q;
    always @(posedge clk or posedge rst)
    begin
        if(rst)
            Q <= Q;                 //if rst = 1, output remains unchanged
        else
            Q <= D;                 //if rst = 0, output = input (at positive edge of clock)
    end
endmodule


//Module for a 2:1 Multiplexer
module mux(sel, i0, i1, Y);

input sel, i0, i1;
output Y;

assign Y = sel ? i1 : i0;
endmodule


//Module for a shift register (PISO mode)
module shift_register(input [7:0]a, input shift, input clk, input rst, input sum, output out, output [7:0]sumout);
    wire [7:0]temp;
    wire [7:0]temp1;

    //Consists of 8 D flipflops
    //If rst = 1, the contents of the register do not change (required to hold the sum after 8 clock cycles)
    //If shift = 0, parallel loading of the 8 bits into the register occurs
    //If shift = 1, the contents shift one bit to the right in each clock cycle
    DFF dff7(.clk(clk), .rst(rst), .D(temp[7]), .Q(temp1[7]));
    DFF dff6(.clk(clk), .rst(rst), .D(temp[6]), .Q(temp1[6]));
    DFF dff5(.clk(clk), .rst(rst), .D(temp[5]), .Q(temp1[5]));
    DFF dff4(.clk(clk), .rst(rst), .D(temp[4]), .Q(temp1[4]));
    DFF dff3(.clk(clk), .rst(rst), .D(temp[3]), .Q(temp1[3]));
    DFF dff2(.clk(clk), .rst(rst), .D(temp[2]), .Q(temp1[2]));
    DFF dff1(.clk(clk), .rst(rst), .D(temp[1]), .Q(temp1[1]));
    DFF dff0(.clk(clk), .rst(rst), .D(temp[0]), .Q(temp1[0]));
    mux mux7(.sel(shift), .i0(a[7]), .i1(sum), .Y(temp[7]));
    mux mux6(.sel(shift), .i0(a[6]), .i1(temp1[7]), .Y(temp[6]));
    mux mux5(.sel(shift), .i0(a[5]), .i1(temp1[6]), .Y(temp[5]));
    mux mux4(.sel(shift), .i0(a[4]), .i1(temp1[5]), .Y(temp[4]));
    mux mux3(.sel(shift), .i0(a[3]), .i1(temp1[4]), .Y(temp[3]));
    mux mux2(.sel(shift), .i0(a[2]), .i1(temp1[3]), .Y(temp[2]));
    mux mux1(.sel(shift), .i0(a[1]), .i1(temp1[2]), .Y(temp[1]));
    mux mux0(.sel(shift), .i0(a[0]), .i1(temp1[1]), .Y(temp[0]));
    assign out = temp1[0];
    assign sumout = temp1;
endmodule


//Module for a fulladder
module fulladder2(input a, input b, input cin, output sum, output carry);
    wire temp1, temp2, temp3;
    xor(sum, a, b, cin);                        //sum = a ^ b ^ cin
    and(temp1, a, b);
    and(temp2, b, cin);
    and(temp3, cin, a);
    or(carry, temp1, temp2, temp3);             //carry = ab + bc + ca
endmodule


//Module for serial adder
module serial_adder(input [7:0]a, input [7:0]b, input cin, input shift, input clk, input rst, output [7:0]sum, output cout);
    wire temp1, temp2, temp3, temp4, temp5, temp7;

    //Consists of two shift registers S1 and S2 for storing the inputs a and b, and one shift register S3 for storing the sum
    shift_register S1(.a(a), .shift(shift), .clk(clk), .rst(rst), .sum(1'b0), .out(temp2), .sumout());
    shift_register S2(.a(b), .shift(shift), .clk(clk), .rst(rst), .sum(1'b0), .out(temp3), .sumout());
    shift_register S3(.a(1'b0), .shift(shift), .clk(clk), .rst(rst), .sum(temp1), .out(), .sumout(sum));

    //Fulladder to generate 1 sum bit and carry in each clock cycle
    fulladder2 fa(.a(temp2), .b(temp3), .cin(temp4), .sum(temp1), .carry(temp5));
    
    mux muxa(.sel(shift), .i0(cin), .i1(temp5), .Y(temp7));

    //D flipflop to store the carry generated in each clock cycle to be used in the next clock cycle
    DFF dff(.clk(clk), .D(temp7), .Q(temp4));
    assign cout = temp5;            //After 8 clock cycles the sum and cout values stabilise            
    
endmodule




