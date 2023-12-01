`include "head.h"

module arbiter(
    input wire clk,
    input wire reset,

    input wire in0,
    output reg out0,

    input wire in1,
    output reg out1,

    input wire in2,
    output reg out2,

    input wire in3,
    output reg out3

);

    reg [1:0] owner; // 1/4 can use bus

    // only set a 1 and there 0,according by owner;
    always @(posedge clk)
        begin
            out1=0;
            out2=0;
            out3=0;
            out0=0;

            case(owner)
                0:begin
                    out0=1;
                end

                1:begin
                    out1=1;
                end

                2:begin
                    out2=1;
                end

                3:begin
                    out3=1;
                end
            endcase
        end

    // rotate use bus: 
    // last route 0 use bus,next route,1 first use,then 2,then 3
    // if 1 dont use,then 2 first,then 3,then 0,

    // 轮转算法，优先级一样
    always @(posedge clk or posedge reset)
        begin
            if(reset == 1'b1)
                begin
                    //异步复位
                    owner <= #RESET 2'b00;
                end
            else
                begin
                    case(owner)
                    2'b00 : 
                        begin
                            if (in0 == 1'b1) begin			
                                owner <= #RESET 2'b00;
                            end else if (in1 == 1'b1) begin 
                                owner <= #RESET 2'b01;
                            end else if (in2 == 1'b1) begin 
                                owner <= #RESET 2'b10;
                            end else if (in3 == 1'b1) begin
                                owner <= #RESET 2'b11;
                            end
                        end
                    2'b01 : 
                        begin
                            if (in1 == 1'b1) begin			
                                owner <= #RESET 2'b01;
                            end else if (in2 == 1'b1) begin 
                                owner <= #RESET 2'b10;
                            end else if (in3 == 1'b1) begin
                                owner <= #RESET 2'b11;
                            end else if (in0 == 1'b1) begin 
                                owner <= #RESET 2'b00;
                            end
                        end
                    2'b10 : 
                        begin
                            if (in2 == 1'b1) begin 
                                owner <= #RESET 2'b10;
                            end else if (in3 == 1'b1) begin
                                owner <= #RESET 2'b11;
                            end else if (in0 == 1'b1) begin			
                                owner <= #RESET 2'b00;
                            end else if (in1 == 1'b1) begin 
                                owner <= #RESET 2'b01;
                            end
                        end
                    2'b11 : 
                        begin
                            if (in3 == 1'b1) begin
                                owner <= #RESET 2'b11;
                            end else if (in0 == 1'b1) begin			
                                owner <= #RESET 2'b00;
                            end else if (in1 == 1'b1) begin 
                                owner <= #RESET 2'b01;
                            end else if (in2 == 1'b1) begin 
                                owner <= #RESET 2'b10;
                            end
                        end
                    endcase
                end
        end
endmodule