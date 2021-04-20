/* Assignment No.: 3 
   Problem No.: 1
   Semester: 5
   Group No.: G18
   Names: Debajyoti Kar (18CS10011), Sagnik Roy (18CS10063) */

module unsigned_array_mult_test;
    reg [5:0]a;
    reg [5:0]b;
    wire [11:0]product;
    integer i;

    unsigned_array_mult u1(a, b, product);

    initial begin
        $dumpfile("dumpfile.vcd");
        $dumpvars(0, unsigned_array_mult_test);
    end

    initial begin

        //Testing for various values of a and b
        a = 1; b = 6; #1
        a = 2; b = 19; #1
        a = 6; b = 4; #1
        a = 14; b = 45; #1
        a = 17; b = 0; #1
        a = 23; b = 60; #1
        a = 54; b = 33; #1
        $finish;
    end

endmodule