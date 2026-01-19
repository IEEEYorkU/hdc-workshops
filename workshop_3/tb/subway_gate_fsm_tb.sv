/*
 * Testbench for Subway Gate FSM
 * Description: verification environment to test "Happy Path" and Reset behavior.
 */

`timescale 1ns / 1ps

module subway_gate_fsm_tb;

    // ==========================================
    // 1. SIGNAL DECLARATION
    // ==========================================
    // "Reg" vs "Wire" in TB:
    // - If we drive it (like an input switch), we use 'logic' or 'reg'.
    // - If we read it (like an output LED), we use 'logic' or 'wire'.
    logic clk;
    logic rst;
    logic presto_success_i;
    logic unlock_gate_o;

    // ==========================================
    // 2. DUT INSTANTIATION (Device Under Test)
    // ==========================================
    subway_gate_fsm DUT (
        .clk              (clk),
        .rst              (rst),
        .presto_success_i (presto_success_i),
        .unlock_gate_o    (unlock_gate_o)
    );

    // ==========================================
    // 3. CLOCK GENERATION
    // ==========================================
    // Create a 10ns clock period (100 MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Toggle every 5 time units
    end

    // ==========================================
    // 4. STIMULUS (The Test Scenario)
    // ==========================================
    initial begin
        // Setup formatting for the console output
        $display("----------------------------------------------------------------");
        $display("Time | Reset | Start Signal | Gate Output | Internal State");
        $display("----------------------------------------------------------------");

        // Monitor: Prints a line whenever any of these signals change
        // Note: DUT.state allows us to peek inside the module!
        $monitor("%4t |   %b   |      %b       |      %b      | %s",
                 $time, rst, presto_success_i, unlock_gate_o, DUT.state.name());

        // --- STEP 1: INITIALIZE ---
        rst = 1;
        presto_success_i = 0;

        // Hold reset for 20ns to make sure everything is clean
        #20;
        rst = 0;
        $display("Info: Reset Released.");

        // --- STEP 2: APPLY INPUT (SWIPE CARD) ---
        #20; // Wait a bit
        $display("Info: Swiping Card (Asserting presto_success_i)...");

        // Synchronize with clock edge for clean input
        @(posedge clk);
        presto_success_i = 1;

        @(posedge clk);
        presto_success_i = 0; // Pulse it for just 1 cycle

        // --- STEP 3: OBSERVE AUTOMATIC BEHAVIOR ---
        // The gate should now be OPEN.
        // The internal counter should be counting.
        // We just wait and watch the logs/waveform.

        #100; // Wait long enough for the counter (count to 7) to finish

        // --- STEP 4: FINISH ---
        $display("----------------------------------------------------------------");
        $display("Test Complete.");
        $finish; // Stop simulation
    end

endmodule
