`timescale 1ns/1ps
module abc_tb();

    reg a, b, c, q;

    abc abc_i (
        // Inputs
        .a(a),
        .b(b),
        .c(c),

        // Outputs
        .q(q)
    );

    initial begin
        a = 0;
        b = 0;
        c = 0;

        #1;

        a = 0;
        b = 1;
        c = 1;

        #25;

        $finish;
    end

endmodule
