/* Assignment No.: 4 
   Problem No.: 3
   Semester: 5
   Group No.: G18
   Names: Debajyoti Kar (18CS10011), Sagnik Roy (18CS10063) */

module GCD_Calculator_test;
	reg clk, rst, start;
	reg [7:0]P;
	reg [7:0]Q;
	wire [7:0]R;
	wire valid;
	wire [1:0] State_Y;
	GCD_Calculator gcd1(clk, rst, start, P, Q, R, valid, State_Y);

	initial begin
        $dumpfile("dumpfile.vcd");
        $dumpvars(0, GCD_Calculator_test);
        P = 8'b01001000;
        Q = 8'b00011110;
        clk = 1'b0;
        rst = 1'b0;
        start = 1'b0;
        #5 rst = 1'b1;
        #15 rst = 1'b0;
        #5 start = 1'b1;
        #15 start = 1'b0;
        
        $monitor("GCD = %d",R);
    end

    always #5 clk = ~clk;
    initial begin
    	#2000 $finish;
	end
endmodule