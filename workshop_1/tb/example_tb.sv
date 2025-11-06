`timescale 1ns/1ps

module example_tb();

    logic hi, bye;

    example example_i (
        .hi(hi),
        .bye(bye)
    );

    initial begin
        hi = 1;
        #1;

        $finish;
    end

endmodule
