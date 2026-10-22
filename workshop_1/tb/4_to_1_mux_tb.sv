`timescale 1ns/1ps

`define RESET_CYCLES 5
`define TIMEOUT      1000

module 4_to_1_mux_tb();

    logic rst = 1;
    logic clk = 0;

    // Clock simulation.
    always begin
        #1 clk = ~clk;
    end

    logic a_0, a_1, a_2, a_3, b;
    logic [1:0] sel;

    4_to_1_mux mux_i (
        // Inputs
        .a_0(a_0),
        .a_1(a_1),
        .a_2(a_2),
        .a_3(a_3),
        .sel_i(sel),

        // Outputs
        .b_o(b)
    );

    initial begin
        {a_3, a_2, a_1, a_0} = '0;
        sel = 2'd0;
        wait(rst == 0); // Wait for reset

        {a_3, a_2, a_1, a_0} = 4'b0001;
        sel = 2'd0;
        #1;     // Wait for 1 cycle so combinational output is ready.

        $display("  %0b  |  %0b  |  %0b  | %0b  |  %0b  |",
                 a_3, a_2, a_0, a_1, b);
        if (b !== a_0) begin
            $display("FAIL: a_0=1, sel=0, b=0");
            $finish;

        {a_3, a_2, a_1, a_0} = 4'b0010;
        sel = 2'd1;
        #1;     // Wait for 1 cycle so combinational output is ready.

        $display("  %0b  |  %0b  |  %0b  | %0b  |  %0b  |",
                 a_3, a_2, a_0, a_1, b);
        if (b !== a_1) begin
            $display("FAIL: a_1=1, sel=1, b=0");
            $finish;

        {a_3, a_2, a_1, a_0} = 4'b0100;
        sel = 2'd2;
        #1;     // Wait for 1 cycle so combinational output is ready.

        $display("  %0b  |  %0b  |  %0b  | %0b  |  %0b  |",
                 a_3, a_2, a_0, a_1, b);
        if (b !== a_2) begin
            $display("FAIL: a_2=1, sel=2, b=0");
            $finish;

        {a_3, a_2, a_1, a_0} = 4'b1000;
        sel = 2'd3;
        #1;     // Wait for 1 cycle so combinational output is ready.

        $display("  %0b  |  %0b  |  %0b  | %0b  |  %0b  |",
                 a_3, a_2, a_0, a_1, b);
        if (b !== a_3) begin
            $display("FAIL: a_3=1, sel=3, b=0");
            $finish;

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
        $dumpfile("4_to_1_mux_tb.vcd");
        $dumpvars(0, 4_to_1_mux_tb);
        $system("date");
    end

endmodule
