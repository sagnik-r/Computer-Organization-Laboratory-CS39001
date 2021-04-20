/* Assignment No.: 3
   Problem No.: 2
   Semester: 5
   Group No.: G18
   Names: Debajyoti Kar (18CS10011), Sagnik Roy (18CS10063) */

module unsigned_seq_mult_LS_test;
    reg clk, rst, load;
    reg [5:0]a;
    reg [5:0]b;
    wire [11:0]product;

    unsigned_seq_mult_LS u1(clk, rst, load, a, b, product);

    initial begin
        $dumpfile("dumpfile.vcd");
        $dumpvars(0, unsigned_seq_mult_LS_test);
        
        //We take some arbitrary values of a and b
        a = 6'b011101;
        b = 6'b001101;

        clk = 1'b0;
        rst = 1'b0;
        load = 1'b0;
        #2 load = 1'b1;             //We make load = 1 to load the input bits into the registers in the first clock cycle
        #5 load = 1'b0;
      
    end

    always #5 clk = ~clk;

    initial begin
        #70 rst = 1'b1;             //We make rst = 1 to hold the final value of the product
        #30 $finish;
    end
endmodule