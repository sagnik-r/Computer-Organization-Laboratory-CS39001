/* Assignment No.: 4 
   Problem No.: 3
   Semester: 5
   Group No.: G18
   Names: Debajyoti Kar (18CS10011), Sagnik Roy (18CS10063) */

module Datapath (clk, rst, Ldp, Ldq, Ldr, Selp, Selq, Sela, Selb, P, Q, eq, gth, R);
	input clk, rst;//Direct Input
	input Ldp, Ldq, Ldr, Selp, Selq, Sela, Selb;//Control path input (Control Unit ---> datapath)
	input [7:0]P, Q;//Direct Input
	output eq, gth;//Output to Control Unit
	output [7:0]R;//Direct Output
	reg [7:0]R;
	reg [7:0] Pbus, Qbus, ALU;
	reg[7:0] Abus, Bbus;

	//reg P
	always @(posedge rst or posedge clk)
		begin
			if(rst) Pbus <= 0;
			else if (Ldp)
				begin
					if(Selp) Pbus <= P;
					else Pbus <= ALU;
				end
		end


	//reg Q
	always @(posedge rst or posedge clk)
		begin
			if (rst) Qbus <= 0;
			else if(Ldq)
				begin
					if(Selq) Qbus <= Q;
					else Qbus <= ALU;
				end
		end

	//reg R
	always @(posedge clk)
		if(Ldr) R <= Pbus;
		else R <= R;

	//mux a
	always @( Pbus or Qbus or Sela)
		if (Sela==1) Abus <= Pbus;
		else	Abus <= Qbus;

	//mux b	
	always @( Pbus or Qbus or Selb)
		if (Selb==1) Bbus <= Qbus;
		else Bbus <= Pbus;

	//alu
	always @(Abus or Bbus)
		ALU <= Abus - Bbus;

	//comparator
	assign eq = (Pbus==Qbus) ? 1:0;
	assign gth = (Pbus>Qbus) ? 1:0;

endmodule


module Control_Unit ( clk, rst, start, eq, gth, valid, Ldp, Ldq, Ldr, Selp, Selq, Sela, Selb, State_Y);

	input clk, rst, start;//Direct Inputs to Control Unit
	input eq, gth;//DataPath Inputs (Datapath ---> Control Unit)
	output valid;//Direct Output
	output Ldp, Ldq, Ldr, Selp, Selq, Sela, Selb;//Datapath Output (Control Unit ---> Datapath)
	output [1:0] State_Y;//Direct Output

	reg [7:0] Control_Variable;
	reg [1:0]y, Y;
	wire valid, Ldp, Ldq, Ldr, Selp, Selq, Sela, Selb;
	parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3;

	//Next state Logic

	always @(y or start or eq or gth)
		begin
			case (y)
			S0: if(!start) Y = S0;
				else if(eq) Y = S1;
					else if(gth) Y = S2;
						else Y = S3;

			S1: Y = S0;
			S2: if(eq) Y = S1;
					else if(gth) Y=S2;
						else Y=S3;
			S3: if(eq) Y = S1;
					else if(gth) Y = S2;
						else Y = S3;
			endcase
		end

	//State Register
	always @(posedge rst or negedge clk)
		if(rst) y<=S0;
			else y<=Y;

	//Output Logic

	always @(y)
		case (y)
			S0: Control_Variable = 8'b11001100;
			S1: Control_Variable = 8'b00000011;
			S2: Control_Variable = 8'b00111000;
			S3: Control_Variable = 8'b00000100;
		endcase

	//Assigning output Logic to the control Variable
	assign Selp = Control_Variable[7];
	assign Selq = Control_Variable[6];
	assign Sela = Control_Variable[5];
	assign Selb = Control_Variable[4];
	assign Ldp = Control_Variable[3];
	assign Ldq = Control_Variable[2];
	assign Ldr = Control_Variable[1];
	assign valid = Control_Variable[0];

	assign State_Y = Y;

endmodule

module GCD_Calculator( clk, rst, start, P, Q, R, valid, State_Y);
	input clk, rst, start;
	input [7:0] P,Q;
	output [7:0]R;
	output valid;
	output [1:0] State_Y;

	wire valid, Ldp, Ldq, Ldr, Selp, Selq, Sela, Selb;
	wire eq, gth;
	//Wiring the 2 modules together
	Datapath DP (clk, rst, Ldp, Ldq, Ldr, Selp, Selq, Sela, Selb, P, Q, eq, gth, R);

	Control_Unit CU (clk, rst, start, eq, gth, valid, Ldp, Ldq, Ldr, Selp, Selq, Sela, Selb, State_Y);

endmodule