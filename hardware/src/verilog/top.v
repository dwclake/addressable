/*
 * @author: dwclake
 */

module top (
    input  clk_12,
    input  enable,
    input  spi_clk,
    input  pico,
    input  cs,
    output data_out,
    output [7:0] led
);
    reg [31:0] counter = 32'b0;

    assign led = counter[25:18];

    /* Increment counter each clock tick */
    always @ (posedge clk_12) begin
        counter <= counter + 1;
    end
endmodule
