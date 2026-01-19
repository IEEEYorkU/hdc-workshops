/*
 * Module name: combo_lock_fsm
 * Author: [Student Name]
 * Description: Lab - 2-Number Combination Lock (Sequence: 5 -> 9)
 */

module combo_lock_fsm (
    input  logic       clk,
    input  logic       rst,
    input  logic [3:0] digit_i,   // User input number (0-15)
    input  logic       enter_i,   // Button: 1 = pressed

    output logic       unlock_o   // Solenoid: 1 = Open, 0 = Locked
);

    // ==========================================
    // 1. STATE DEFINITIONS
    // ==========================================

    // BEGINNER NOTE: We use specific names for states so the code reads like English.
    typedef enum logic [1:0] {
        S_IDLE,       // Waiting for first digit (5)
        S_SAW_CODE_1, // Saw '5', waiting for second digit (9)
        S_OPEN        // Saw '9', lock is open
    } state_t;

    state_t state, next_state;

    // ==========================================
    // 2. FSM CONTROL PROCESSES
    // ==========================================

    // --- Process 1: State Memory (Sequential) ---
    // CONCEPT: This updates the physical Flip-Flops on the clock edge.
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= S_IDLE;
        end else begin
            state <= next_state;
        end
    end

    // --- Process 2: Next State Logic (Combinational) ---
    // CONCEPT: "The Brain" - Decides where to go next based on Input + Current State.
    always_comb begin
        // SAFETY NET (CRITICAL): Default to staying in the current state.
        next_state = state;

        case (state)
            S_IDLE: begin
                // TODO: If enter_i is pressed AND digit_i is 5...
                //       Move to S_SAW_CODE_1.
                //       Otherwise, if enter is pressed with wrong digit, stay in IDLE.

                if (enter_i) begin
                     // [YOUR CODE HERE]
                end
            end

            S_SAW_CODE_1: begin
                // TODO: If enter_i is pressed...
                //       Check if digit_i is 9. If yes -> Go to S_OPEN.
                //       If digit_i is WRONG -> Go back to S_IDLE (Security reset!).

                if (enter_i) begin
                     // [YOUR CODE HERE]
                end
            end

            S_OPEN: begin
                // TODO: If they press enter again, lock the door (Go to S_IDLE).

                if (enter_i) begin
                     // [YOUR CODE HERE]
                end
            end

            // Good practice to include default even if all enums are covered
            default: next_state = S_IDLE;
        endcase
    end

    // --- Process 3: Output Logic (Moore - Combinational) ---
    // CONCEPT: Output depends ONLY on current state.
    always_comb begin
        // BEST PRACTICE: Set default values for all outputs at the very top.
        unlock_o = 1'b0;

        case (state)
            // TODO: Set unlock_o to 1 ONLY when we are in the S_OPEN state.
            //       (Use the case statement or a simple if-statement inside)

            S_IDLE: begin
                 // [YOUR CODE HERE]
            end

            S_SAW_CODE_1: begin
                 // [YOUR CODE HERE]
            end

            S_OPEN: begin
                 // [YOUR CODE HERE]
            end
        endcase
    end

endmodule
