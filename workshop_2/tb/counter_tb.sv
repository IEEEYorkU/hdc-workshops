`timescale 1ns / 1ps

// This is the testbench module
module counter_tb;

    // --- Test Parameters ---
    // You can change these values to test different configurations
    localparam DWIDTH     = 5;
    localparam INC_SIZE   = 1; // Try with 1, 2, or 3!
    localparam MAX_COUNT  = (2**DWIDTH) - 1;

    // --- Clock Generation ---
    localparam int CLK_PERIOD = 10; // 10ns clock period
    reg clk;
    initial begin
        clk = 0;
        forever #(CLK_PERIOD / 2) clk = ~clk;
    end

    // --- Signals to connect to the DUT ---
    reg  reset;
    wire [DWIDTH-1:0] count;   // Monitor the counter's value
    wire complete;            // Monitor the 'complete' flag

    // --- Instantiate the DUT (Device Under Test) ---
    counter #(
        .DWIDTH(DWIDTH),
        .INC_SIZE(INC_SIZE)
    ) dut (
        .clk(clk),
        .reset(reset),
        .count(count),       // Connect to our monitor wire
        .complete(complete)
    );

    // --- Test Sequence ---
    initial begin
        // --- Declarations must come FIRST inside a block ---
        int num_cycles_to_run = (2**DWIDTH) * 2;

        $display("--- Test Start ---");
        $display("DWIDTH=%0d, INC_SIZE=%0d, MAX_COUNT=%0d", DWIDTH, INC_SIZE, MAX_COUNT);

        // 1. Assert Reset
        reset = 1;
        $display("Time=%0t | Reset Asserted", $time);
        @(posedge clk);
        @(posedge clk);

        // 2. De-assert Reset
        reset = 0;
        $display("Time=%0t | Reset De-asserted, starting count", $time);

        // 3. Run for enough cycles to see two full wraps
        // We calculate (2**DWIDTH) as the number of states.
        // We multiply by 2 to see it wrap twice.
        // int num_cycles_to_run = (2**DWIDTH) * 2; // <-- MOVED THIS LINE UP
        repeat (num_cycles_to_run) @(posedge clk);

        // 4. End simulation
        $display("Time=%0t | Test Finished", $time);
        $finish;
    end

    // --- Monitoring and Verification ---

    // $monitor will print every time a signal in its list changes
    initial begin
        // Wait for reset to finish
        @(negedge reset);

        // Start monitoring
        $monitor("Time=%0t | Count = %0d | Complete = %b", $time, count, complete);
    end

    // Automatic check (Assertion)
    // This runs on every positive clock edge
    always @(posedge clk) begin
        // Don't check during reset
        if (!reset) begin
            // We use #1ps to sample the signals just *after* the clock edge,
            // allowing the combinatorial 'complete' logic to update.
            #1ps;

            // Check: Is the 'complete' signal correct for the current count?
            assert (complete == (count == MAX_COUNT))
                else $error("Assertion failed at Time=%0t! Count=%0d, but Complete=%b", $time, count, complete);
        end
    end

endmodule