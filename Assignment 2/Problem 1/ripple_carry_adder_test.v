module ripple_carry_adder_test;
    reg [7:0]a;
    reg [7:0]b;
    reg cin;
    wire [7:0]sum;
    wire cout;
    integer i;

    ripple_carry_adder r1(a, b, cin, sum, cout); 

    initial begin
        $dumpfile("dumpfile.vcd");
        $dumpvars(0, ripple_carry_adder_test);
        
        //Initialize the values of a, b and cin
        a = 8'b00000000;
        b = 8'b00000000;
        cin = 1'b0; 
    end

    always #5 cin = ~cin;           //We change the input carry bit after every 5 units of time
    initial begin
        for(i = 0; i <= 1024; i = i + 1)
            begin
                #1 {a,b} = i;
            end
        #10
        $finish;
    end
endmodule