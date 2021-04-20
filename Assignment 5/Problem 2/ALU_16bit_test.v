/* Assignment No.: 5
   Problem No.: 2
   Semester: 5
   Group No.: G18
   Names: Debajyoti Kar (18CS10011), Sagnik Roy (18CS10063) */

module ALU_16bit_test;
	reg [15:0] A;
	reg [15:0] B;
	reg [3:0] S;
	reg Cin;
	reg M;

	wire [15:0] F;
	wire Cout;

	ALU_16bit alu1(.A(A), .B(B), .S(S), .Cin(Cin), .M(M), .F(F), .Cout(Cout));

	initial begin
        $dumpfile("dumpfile.vcd");
        $dumpvars(0, ALU_16bit_test);
        A = 16'b0000000000001011;
        B = 16'b0000000000000111;
        Cin = 1'b1;
        S = 4'b0000;
        M = 1'b0;

        $monitor("A = %b, B = %b, S = %b, M = %b, Cout = %b F = %b", A, B, S, M, Cout, F); 
    end

    initial begin
    	#5 S = 4'b0001;
    	#5 S = 4'b0010;
    	#5 S = 4'b0011;
    	#5 S = 4'b0100;
    	#5 S = 4'b0101;
    	#5 S = 4'b0110;
    	#5 S = 4'b0111;
    	#5 S = 4'b1000;
    	#5 S = 4'b1001;
    	#5 S = 4'b1010;
    	#5 S = 4'b1011;
    	#5 S = 4'b1100;
    	#5 S = 4'b1101;
    	#5 S = 4'b1110;
    	#5 S = 4'b1111;
    	#5 M = 1'b1;
    	   S = 4'b0000;
    	#5 S = 4'b0001;
    	#5 S = 4'b0010;
    	#5 S = 4'b0011;
    	#5 S = 4'b0100;
    	#5 S = 4'b0101;
    	#5 S = 4'b0110;
    	#5 S = 4'b0111;
    	#5 S = 4'b1000;
    	#5 S = 4'b1001;
    	#5 S = 4'b1010;
    	#5 S = 4'b1011;
    	#5 S = 4'b1100;
    	#5 S = 4'b1101;
    	#5 S = 4'b1110;
    	#5 S = 4'b1111;
    	#5 $finish;
    end
endmodule