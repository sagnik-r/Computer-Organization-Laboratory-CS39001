/* Assignment No.: 4 
   Problem No.: 2
   Semester: 5
   Group No.: G18
   Names: Debajyoti Kar (18CS10011), Sagnik Roy (18CS10063) */

module multiple_of_three(input clk, input rst, input inp, output reg outp);
    reg [1:0]state;
    parameter A = 0, B = 1, C = 2;              //There are 3 states in the FSM

    always @(posedge clk or posedge rst)
        begin
            if(rst)
                state = A;                      //Initialize the FSM to state A
            else
                begin
                    //State transition rules
                    case(state)

                        //FSM is in state A if the current remainder is 0
                        A:  begin                
                            state = inp ? B : A;
                            outp = inp ? 1'b0 : 1'b1;
                        end

                        /*FSM is in state B if either i)current remainder is 1 and no. of bits seen till now is odd
                                                     ii)current remainder is 2 and no. of bits seen till now is even */
                        B:  begin                
                            state = inp ? A : C;                             
                            outp = inp ? 1'b1 : 1'b0;
                        end

                        /*FSM is in state C if either i)current remainder is 1 and no. of bits seen till now is even
                                                     ii)current remainder is 2 and no. of bits seen till now is odd */
                        C:  begin
                            state = inp ? C : B;
                            outp = 1'b0;
                        end
                        
                    endcase
                end
        end
endmodule













