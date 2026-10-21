module full_adder (
    input  logic a_i,
    input  logic b_i,
    input  logic carry_i,

    output logic sum_o,
    output logic carry_o
);

    // First half adder instantiation
    logic h1_sum;
    logic h1_carry;

    half_adder h1 (
        .a_i    (a_i),
        .b_i    (b_i),
        .sum_o  (h1_sum),
        .carry_o(h1_carry)
    );

    // Second half adder instantiation
    logic h2_carry;

    half_adder h2 (
        .a_i    (h1_sum),
        .b_i    (carry_i),
        .sum_o  (sum_o),
        .carry_o(h2_carry)
    );

    // Full adder carry output
    assign carry_o = h1_carry || h2_carry;

endmodule
