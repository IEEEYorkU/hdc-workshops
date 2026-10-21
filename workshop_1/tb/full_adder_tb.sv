`timescale 1ns/1ps

`define RESET_CYCLES 5
`define TIMEOUT      1000

module full_adder_tb();

    logic rst = 1;
    logic clk = 0;

    // Clock simulation.
    always begin
        #1 clk = ~clk;
    end

    logic a_i;
    logic b_i;
    logic carry_i;
    logic sum_o;
    logic carry_o;

    // Instantiate the half adder
    full_adder dut (
        .a_i(a_i),
        .b_i(b_i),
        .carry_i(carry_i),
        .sum_o(sum_o),
        .carry_o(carry_o)
    );

    initial begin
        $display("========================================");
        $display(" Half Adder Testbench");
        $display("========================================");
        $display(" a_i | b_i | sum_o | carry_o");
        $display("----------------------------------------");
        wait(rst == 0); // Wait for reset

        // Test case 1: 0 + 0
        a_i = 0; 
        b_i = 0;
        carry_i = 0;

        #1;
        $display("  %0b  |  %0b  |  %0b  |   %0b   |    %0b",
                 a_i, b_i, carry_i, sum_o, carry_o);
        if (sum_o !== 0 || carry_o !== 0) begin
            $display("FAIL: a_i=0, b_i=0, carry_i=0");
            $finish;
        end

        // Add more tests cases...

        $display("----------------------------------------");
        $display("Success! All full adder tests completed.");
        $finish;
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
        $dumpfile("full_adder_tb.vcd");
        $dumpvars(0, full_adder_tb);
        $system("date");
    end

endmodule
