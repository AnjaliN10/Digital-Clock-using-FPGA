/*
 * FPGA-Based Digital Clock Design
 * -------------------------------
 * This module implements a 24-hour digital clock using counters.
 * Time is maintained in hours, minutes, and seconds.
 *
 * Note:
 * - Designed for learning and demonstration purposes
 * - Hardware-independent RTL
 */

module digital_clock (
    input  wire clk,        // System clock
    input  wire reset,      // Synchronous reset
    output reg  [5:0] seconds,
    output reg  [5:0] minutes,
    output reg  [4:0] hours
);

    // Clock divider parameter (adjust based on FPGA clock frequency)
    // Example: For 50 MHz clock → COUNT_MAX = 50_000_000
    parameter COUNT_MAX = 50_000_000;

    reg [31:0] clk_count;

    // Clock divider: generates 1-second enable pulse
    always @(posedge clk) begin
        if (reset) begin
            clk_count <= 0;
        end else if (clk_count == COUNT_MAX - 1) begin
            clk_count <= 0;
        end else begin
            clk_count <= clk_count + 1;
        end
    end

    wire one_second_enable = (clk_count == COUNT_MAX - 1);

    // Timekeeping logic
    always @(posedge clk) begin
        if (reset) begin
            seconds <= 0;
            minutes <= 0;
            hours   <= 0;
        end
        else if (one_second_enable) begin

            // Increment seconds
            if (seconds == 59) begin
                seconds <= 0;

                // Increment minutes
                if (minutes == 59) begin
                    minutes <= 0;

                    // Increment hours
                    if (hours == 23)
                        hours <= 0;
                    else
                        hours <= hours + 1;

                end else begin
                    minutes <= minutes + 1;
                end

            end else begin
                seconds <= seconds + 1;
            end

        end
    end

endmodule
