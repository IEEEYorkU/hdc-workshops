/*
 * Module name: subway_gate_fsm
 * Author: Kiet Le
 * Description: Introduction to Finite State Machines (FSMs)
 * * BEGINNER NOTE:
 * We use 'logic' for almost everything in SystemVerilog.
 * It replaces the confusing 'reg' vs 'wire' rules from older Verilog.
 */

module subway_gate_fsm (
    input  logic clk,
    input  logic rst,            // Async Reset (System Reset)
    input  logic presto_success_i, // "Start" signal

    output logic unlock_gate_o   // Output
);

    // ==========================================
    // 1. DATAPATH: The Timer
    // ==========================================
    // CONCEPT: The FSM is the "Boss" (Control). The Counter is the "Worker" (Datapath).
    // The Boss shouldn't waste brainpower counting 1, 2, 3... it just tells the Worker
    // to start and waits for the Worker to say "Done".

    localparam int COUNTER_DWIDTH = 3;

    logic cnt_rst;        // Control signal FROM FSM
    logic cnt_complete;   // Status signal TO FSM

    counter #(
        .DWIDTH(COUNTER_DWIDTH)
    ) cnt_i (
        .clk        (clk),
        .reset      (cnt_rst),
        .complete_o (cnt_complete),
        .count_o    ()              // BEGINNER NOTE: Empty parenthesis () mean we leave this port unconnected.
                                    // We only care *if* it is done, not what the specific number is.
    );

    // ==========================================
    // 2. CONTROL: The FSM
    // ==========================================

    // BEGINNER NOTE: Using 'enum' makes waveforms readable.
    // Instead of seeing "state = 0", you will see "state = STATE_CLOSED" in the debugger.
    typedef enum logic [1:0] {
        STATE_CLOSED,
        STATE_OPEN
    } state_t;

    state_t state, next_state;

    // --- Process 1: State Memory (Sequential) ---
    // CONCEPT: This is the only part of the FSM that "remembers" things.
    // It creates the physical Flip-Flops.
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= STATE_CLOSED;
        end else begin
            // CRITICAL SYNTAX: Use Non-Blocking assignments (<=) for Sequential logic.
            // This ensures all registers update synchronously at the end of the clock cycle.
            state <= next_state;
        end
    end

    // --- Process 2: Next State Logic (Combinational) ---
    // CONCEPT: This is a cloud of logic gates that decides where to go NEXT.
    // It happens immediately (no clock wait), so we use Blocking assignments (=).
    always_comb begin
        // SAFETY NET (CRITICAL): Default to staying in the current state.
        // If you forget an 'else' inside the case statement, this line prevents
        // the tool from inferring a "Latch" (broken memory).
        next_state = state;

        case (state)
            STATE_CLOSED: begin
                if (presto_success_i) begin
                    next_state = STATE_OPEN;
                end
                // implicit 'else': next_state = state (handled by safety net above)
            end

            STATE_OPEN: begin
                // Wait for the datapath (counter) to tell us it's done
                if (cnt_complete) begin
                    next_state = STATE_CLOSED;
                end
            end
        endcase
    end

    // --- Process 3: Output Logic (Moore - Combinational) ---
    // CONCEPT: Moore Machine -> Output depends ONLY on current state.
    // This makes the design stable and easier to debug.
    always_comb begin
        // BEST PRACTICE: Set default values for all outputs at the very top.
        // This ensures you never accidentally create a latch by forgetting to assign a value in one case.
        unlock_gate_o = 1'b0;
        cnt_rst       = 1'b0;

        case (state)
            STATE_CLOSED: begin
                unlock_gate_o = 1'b0; // Gate Locked
                cnt_rst       = 1'b1; // HOLD the worker in reset while we wait.
            end

            STATE_OPEN: begin
                unlock_gate_o = 1'b1; // Gate Open
                cnt_rst       = 1'b0; // RELEASE the worker so it can count.
            end
        endcase
    end

endmodule
