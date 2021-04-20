/* Assignment No.: 2 
   Problem No.: 3
   Semester: 5
   Group No.: G18
   Names: Debajyoti Kar (18CS10011), Sagnik Roy (18CS10063) */


module serial_adder_test;
    reg [7:0]a;
    reg [7:0]b;
    reg cin;
    reg shift, clk, rst;
    wire [7:0]sum;
    wire cout;

    serial_adder sa(a, b, cin, shift, clk, rst, sum, cout);

    initial 
    begin
        $dumpfile("dumpfile.vcd");
        $dumpvars(0, serial_adder_test);

        //We choose some arbitrary inputs for a, b and cin
        a = 8'b00011101;
        b = 8'b10001101;
        cin = 1'b1;
        shift = 1'b0;           //Initialise shift = 0 to load a and b into the registers 
        clk = 1'b0;
        rst = 1'b0;             //Initialise rst = 0 so that register functions
        #7 shift = 1'b1;        //Now shift = 1, so the addition process starts and sum bits start getting generated
    end

    always #5 clk = ~clk;

    initial begin
        #87 rst = 1'b1;         //After 8 clock cycles, make rst = 1 to hold the sum bits
        #30
        $finish;
    end

endmodule