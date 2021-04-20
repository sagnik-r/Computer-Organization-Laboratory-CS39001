/* Assignment No.: 5
   Problem No.: 2
   Semester: 5
   Group No.: G18
   Names: Debajyoti Kar (18CS10011), Sagnik Roy (18CS10063) */

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
module CLA_Adder(input [3:0]a, input [3:0]b, input cin, output [3:0]sum, output cout);
    wire [4:0]temp;
    wire [3:0]p;
    wire [3:0]g;
    genvar i;
    wire PG, GG;
    //It has 4 fulladders and a 4- bit Carry Lookahead Unit
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


module complement(input [3:0] A, output [3:0] B);

	not n0(B[0], A[0]);
	not n1(B[1], A[1]);
	not n2(B[2], A[2]);
	not n3(B[3], A[3]);

endmodule


module ALU(A, B, S, F, Cin, Cout, M);
	/*Declaration of input ports*/

	input [3:0] A;
	input [3:0] B;
	input [3:0] S;
	input Cin;
	input M;

	/*Declaration of output ports*/
	output reg [3:0] F;
	output reg Cout;

	wire Cin_use;
	reg Cout_in;
	not Cin_not (Cin_use, Cin);//Cin pin of IC is notted

	wire[3:0] AorB, AorBbar, AandBbar, AandB;//Logical results required arithmetic operations
	genvar g;

	for(g = 0; g < 4; g=g+1)begin
		//Generating the required logical results
		or o2(AorB[g], A[g], B[g]);
		or o3(AorBbar[g], A[g], ~B[g]);
		and a5(AandBbar[g], A[g], ~B[g]);
		and a6(AandB[g], A[g], B[g]);
	end

	wire[3:0] AplusABbar, AorBplusABbar, AplusAB, AplusB; 
	wire[3:0] AorBbarplusAB, AplusA, AorBplusA, AorBbarplusA;
	wire[3:0] Bcomp, AminusB, ABbarminus1, ABminus1, Aminus1;
	//Arithmetic Computation Results
	wire t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11, t12;

	CLA_Adder ra1(.a(A), .b(AandBbar), .cin(Cin_use), .sum(AplusABbar), .cout(t1));//AplusABbar
	CLA_Adder ra2(.a(AorB), .b(AandBbar), .cin(Cin_use), .sum(AorBplusABbar), .cout(t2));//AorBplusABbar
	CLA_Adder ra3(.a(A), .b(AandB), .cin(Cin_use), .sum(AplusAB), .cout(t3));//AplusAB
	CLA_Adder ra4(.a(A), .b(B), .cin(Cin_use), .sum(AplusB), .cout(t4));//AplusB
	CLA_Adder ra5(.a(AorBbar), .b(AandB), .cin(Cin_use), .sum(AorBbarplusAB), .cout(t5));//AorBbarplusAB
	CLA_Adder ra6(.a(A), .b(A), .cin(Cin_use), .sum(AplusA), .cout(t6));//AplusA
	CLA_Adder ra7(.a(AorB), .b(A), .cin(Cin_use), .sum(AorBplusA), .cout(t7));//AorBplusA
	CLA_Adder ra8(.a(AorBbar), .b(A), .cin(Cin_use), .sum(AorBbarplusA), .cout(t8));//AorBbarplusA

	complement com2(.A(B), .B(Bcomp));//Compute ~B

	CLA_Adder ra9(.a(A), .b(Bcomp), .cin(Cin_use), .sum(AminusB), .cout(t9));//AminusBminus1
	CLA_Adder ra10(.a(AandBbar), .b(4'b1111), .cin(Cin_use), .sum(ABbarminus1), .cout(t10));//ABbarminus1
	CLA_Adder ra11(.a(AandB), .b(4'b1111), .cin(Cin_use), .sum(ABminus1), .cout(t11));//ABminus1
	CLA_Adder ra12(.a(A), .b(4'b1111), .cin(Cin_use), .sum(Aminus1), .cout(t12));//Aminus1

	always @(*)
		begin
			if (M) begin
			//Logical Operation Output
				F[0] <= ((~A[0])&(B[0])&(~S[0]))|((~A[0])&(~B[0])&(~S[1]))|((A[0])&(~B[0])&(S[2]))|((A[0])&(B[0])&(S[3]));
				F[1] <= ((~A[1])&(B[1])&(~S[0]))|((~A[1])&(~B[1])&(~S[1]))|((A[1])&(~B[1])&(S[2]))|((A[1])&(B[1])&(S[3]));
				F[2] <= ((~A[2])&(B[2])&(~S[0]))|((~A[2])&(~B[2])&(~S[1]))|((A[2])&(~B[2])&(S[2]))|((A[2])&(B[2])&(S[3]));
				F[3] <= ((~A[3])&(B[3])&(~S[0]))|((~A[3])&(~B[3])&(~S[1]))|((A[3])&(~B[3])&(S[2]))|((A[3])&(B[3])&(S[3]));
				Cout_in <= Cin_use;
			end
			else begin

				case(S)//Arithmetic Operation Results
				4'b0000: {Cout_in,F} <= A + Cin_use;
				4'b0001: {Cout_in,F} <= AorB + Cin_use;
				4'b0010: {Cout_in,F} <= AorBbar + Cin_use;
				4'b0011: {Cout_in,F} <= 4'b1111;
				4'b0100: begin 
						 F <= AplusABbar;
						 Cout_in <= t1;
						 end	
				4'b0101: begin
						 F <= AorBplusABbar;
						 Cout_in <= t2;
						 end	
				4'b0110: begin
						 F <= AminusB;
						 Cout_in <= t9;
						 end
				4'b0111: begin
						 F <= ABbarminus1;
						 Cout_in <= t10;
						 end
				4'b1000: begin
						 F <= AplusAB;
						 Cout_in <= t3;
						 end
				4'b1001: begin
						 F <= AplusB;
						 Cout_in <= t4;
						 end
				4'b1010: begin
						 F <= AorBbarplusAB;
						 Cout_in <= t5;
						 end
				4'b1011: begin
						 F <= ABminus1;
						 Cout_in <= t11;
						 end
				4'b1100: begin
						 F <= AplusA;
						 Cout_in <= t6;
						 end
				4'b1101: begin
						 F <= AorBplusA;
						 Cout_in <= t7;
						 end
				4'b1110: begin
						 F <= AorBbarplusA;
						 Cout_in <= t8;
						 end
				4'b1111: begin
						 F <= Aminus1;
						 Cout_in <= t12;
						 end
				endcase
			end

			Cout <= ~Cout_in;//The output pin Cout is notted in the IC
		end

		/*  The logical outputs: 
			case(S)
			4'b0000: F <= ~A;
			4'b0001: F <= ~(A|B);
			4'b0010: F <= (~A)&B;
			4'b0011: F <= 4'b0000;
			4'b0100: F <= ~(A&B);
			4'b0101: F <= ~B;
			4'b0110: F <= A^B;
			4'b0111: F <= A&(~B);
			4'b1000: F <= (~A)|B;
			4'b1001: F <= ~(A^B);
			4'b1010: F <= B;
			4'b1011: F <= A&B;
			4'b1100: F <= 4'b0001;
			4'b1101: F <= A|(~B);
			4'b1110: F <= A|B;
			4'b1111: F <= A;
			endcase*/

endmodule	


module ALU_16bit(A, B, S, F, Cin, Cout, S, M);
	/*Declaration of input ports*/

	input [15:0] A;
	input [15:0] B;
	input [3:0] S;
	input Cin;
	input M;

	/*Declaration of output ports*/
	output wire [15:0] F;
	output wire Cout;

	wire t1, t2, t3;//Connecting Wires

	ALU a1(.A(A[3:0]), .B(B[3:0]), .S(S), .F(F[3:0]), .Cin(Cin), .Cout(t1), .M(M));
	ALU a2(.A(A[7:4]), .B(B[7:4]), .S(S), .F(F[7:4]), .Cin(t1), .Cout(t2), .M(M));
	ALU a3(.A(A[11:8]), .B(B[11:8]), .S(S), .F(F[11:8]), .Cin(t2), .Cout(t3), .M(M));
	ALU a4(.A(A[15:12]), .B(B[15:12]), .S(S), .F(F[15:12]), .Cin(t3), .Cout(Cout), .M(M));

endmodule