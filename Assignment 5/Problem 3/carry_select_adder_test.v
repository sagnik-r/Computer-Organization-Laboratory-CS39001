/* Assignment No.: 5
   Problem No.: 3
   Semester: 5
   Group No.: G18
   Names: Debajyoti Kar (18CS10011), Sagnik Roy (18CS10063) */

module carry_select_adder_test;
    reg [15:0]a;
    reg [15:0]b;
    reg cin;
    wire [15:0]sum;
    wire cout;
    
    carry_select_adder csa(a, b, cin, sum, cout); 

    initial begin
        $dumpfile("dumpfile.vcd");
        $dumpvars(0, carry_select_adder_test);
    end

    initial begin

        //Testing with arbitrary inputs
        a = 256; b = 256; cin = 0; #10
        a = 123; b = 543; cin = 1; #10
        a = 32000; b = 32760; cin = 1; #10
        a = 0; b = 0; cin = 0; #10
        a = 20; b = 4566; cin = 0; #10
        a = 3323; b = 20; cin = 1;
        #10 $finish;
    end
endmodule