/* Assignment No.: 4
   Problem No.: 1
   Semester: 5
   Group No.: G18
   Names: Debajyoti Kar (18CS10011), Sagnik Roy (18CS10063) */

module twos_complement_test;
    reg clk, rst, inp;
    wire outp;

    twos_complement t(clk, rst, inp, outp);

    initial begin
        $dumpfile("dumpfile.vcd");
        $dumpvars(0, twos_complement_test);
        clk = 1'b0; rst = 1'b0;
        #2 rst = 1'b1;                  //FSM initialised to state A
        #5 rst = 1'b0;
    end

    always #5 clk = ~clk;

    initial begin

        //Testing with some arbitrary input bits
        #10 inp = 0; #10 inp = 1; #10 inp = 0; #10 inp = 1; #10 inp = 0;
        #10 inp = 1; #10 inp = 1; #10 inp = 0; #10 inp = 1; #10 inp = 0;
        #10 $finish;
    end
endmodule