module abc (
    input   wire a, b, c,
    output  wire q
);

    assign q = (a | c) & b;

endmodule
