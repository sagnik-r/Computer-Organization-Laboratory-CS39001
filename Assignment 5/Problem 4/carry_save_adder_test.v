/* Assignment No.: 5 
   Problem No.: 4
   Semester: 5
   Group No.: G18
   Names: Debajyoti Kar (18CS10011), Sagnik Roy (18CS10063) */

module carry_save_adder_test;
    reg [15:0]a0;
    reg [15:0]a1;
    reg [15:0]a2;
    reg [15:0]a3;
    reg [15:0]a4;
    reg [15:0]a5;
    reg [15:0]a6;
    reg [15:0]a7;
    reg [15:0]a8;
    wire [19:0]sum;

    carry_save_adder CSA(a0, a1, a2, a3, a4, a5, a6, a7, a8, sum);

    initial begin
        $dumpfile("dumpfile.vcd");
        $dumpvars(0, carry_save_adder_test);
    end

    initial begin

        //Testing with arbitrary inputs
        a0 = 140; a1 = 200; a2 = 130; a3 = 20; a4 = 290; a5 = 2800; a6 = 1455; a7 = 1111; a8 = 1234;
        #10 
        a0 = 32000; a1 = 0; a2 = 1235; a3 = 9999; a4 = 23000; a5 = 31222; a6 = 789; a7 = 3333; a8 = 2;
        #10
        $finish;
    end
endmodule
