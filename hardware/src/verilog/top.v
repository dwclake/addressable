/*
 * @author: dwclake
 */

module top (
    input sys_clk,
    output [7:0] led
);

    reg [31:0] counter = 32'b0;

    assign led = counter[25:18];

    always @ (posedge sys_clk) begin
        counter <= counter + 1;
    end

endmodule
