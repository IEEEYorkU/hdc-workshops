`timescale 1ns/1ps

`define RESET_CYCLES 5
`define TIMEOUT      1000

module example_tb();

    logic rst = 1;
    logic clk = 0;

    // Clock simulation.
    always begin
        #1 clk = ~clk;
    end

    logic hi, bye;

    // Module instantiation.
    example example_i (
        .hi(hi),
        .bye(bye)
    );

    // Actualy driving signals in simulation.
    initial begin
        hi = 0;         // Initialized to 0
        wait(rst == 0); // Wait for reset

        hi = 1;
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
        $dumpfile("example_tb.vcd");
        $dumpvars(0, example_tb);
        $system("date");
    end

endmodule
