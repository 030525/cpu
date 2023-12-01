module test_arbiter;

    reg HZ;
    reg clk;
    reg reset;

    reg m0_in_;
    reg m1_in_;
    reg m2_in_;
    reg m3_in_;

    wire m0_out_;
    wire m1_out_;
    wire m2_out_;
    wire m3_out_;


    // Instantiate the arbiter module
    arbiter arbiter_inst (
        .clk(clk),
        .reset(reset),
        .in0(m0_in_),
        .in1(m1_in_),
        .in2(m2_in_),
        .in3(m3_in_),
        .out0(m0_out_),
        .out1(m1_out_),
        .out2(m2_out_),
        .out3(m3_out_)
    );

    initial begin
        clk=0;
        HZ=5;
        forever #HZ clk=~clk;
    end

    initial 
        begin
            m0_in_ = 1'b1;
            m1_in_ = 1'b1;
            m2_in_ = 1'b1;
            m3_in_ = 1'b1;
            reset=1;

            #5 reset = 0;
            #20 $display("m0_out_: %b, m1_out_: %b, m2_out_: %b, m3_out_: %b", m0_out_, m1_out_, m2_out_, m3_out_);
            #10 m0_in_=0;
            #10 m3_in_ = 1'b1;
            #20 $display("m0_out_: %b, m1_out_: %b, m2_out_: %b, m3_out_: %b", m0_out_, m1_out_, m2_out_, m3_out_);
            #100 $finish;
        end
        

endmodule
