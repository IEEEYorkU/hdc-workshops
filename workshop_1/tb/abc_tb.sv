`timescale 1ns/1ps

`define RESET_CYCLES 5
`define TIMEOUT      1000

module abc_tb();

    logic rst = 1;
    logic clk = 0;

    // Clock simulation.
    always begin
        #1 clk = ~clk;
    end

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
        wait(rst == 0); // Wait for reset

        a = 0;
        b = 1;
        c = 1;
        #1;     // Wait for 1 cycle so combinational output is ready.

        $finish;
        $display("========== Simulation Complete ==========");
    end

    // Borrowed from clockgen.sv
    integer counter = 0;
    always_ff @(posedge clk) begin
        counter <= counter + 1;
        if (counter < `RESET_CYCLES) begin
            rst <= 1;
        end else begin
            rst <= 0;
        end

        if (counter >= `TIMEOUT) begin
            $display("========== Simulation TIMEOUT!!! ==========");
            $finish;
        end
    end

    // Saving .vcd files. To be used in gtkwaveor vapor view extension in
    // vscode.
    initial begin
        $dumpfile("abc_tb.vcd");
        $dumpvars(0, abc_tb);
        $system("date");
    end

endmodule
