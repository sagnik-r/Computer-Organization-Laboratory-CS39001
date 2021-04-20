/* Assignment No.: 4 
   Problem No.: 1
   Semester: 5
   Group No.: G18
   Names: Debajyoti Kar (18CS10011), Sagnik Roy (18CS10063) */

module twos_complement (input clk, input rst, input inp, output reg outp);
    reg state;
    parameter A = 0, B = 1;                 //There are 2 states in the FSM

    always @(posedge clk or posedge rst)
        begin
            if(rst)
                begin
                    state = A;              //Initialize the FSM to state A
                end
            else
                begin

                    //State transition rules
                    case(state)
                        A:  begin                           //As long as first 1 does not arrive, FSM is in state A
                            state = inp ? B : A;            
                            outp = inp ? 1'b1 : 1'b0;
                        end
                        B:  begin                           //After the first 1 arrives, the FSM stays in state B
                            state = B;                      
                            outp = inp ? 1'b0 : 1'b1;
                        end
                    endcase
                end
        end
endmodule