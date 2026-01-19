module counter #(
    parameter int DWIDTH = 5,
    parameter int INC_SIZE = 1
)(
    input   wire clk,
    input   wire reset,

    output  wire [DWIDTH-1:0] count_o,
    output  reg complete_o
);
    reg [DWIDTH-1:0] count_i;

    always @(posedge clk) begin
        if (reset) begin
            count_i <= 'b0;
        end else begin
            count_i <= count_i + INC_SIZE;
        end
    end

    assign count = count_i;

    assign complete = (count_i == (2**DWIDTH-1)? 1 : 0);

endmodule
