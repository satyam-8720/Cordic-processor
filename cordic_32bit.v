module cordic #(parameter WIDTH = 32, ITER = 16)(
    input clk,
    input rst,
    input start,
    input mode, // 0 = rotation, 1 = vectoring
    input signed [WIDTH-1:0] x_in,
    input signed [WIDTH-1:0] y_in,
    input signed [WIDTH-1:0] z_in,
    output reg signed [WIDTH-1:0] x_out,
    output reg signed [WIDTH-1:0] y_out,
    output reg signed [WIDTH-1:0] z_out,
    output reg done
);

    localparam signed [WIDTH-1:0] K = 32'sd19898;  // ~0.60725 * 32768
    localparam IDLE = 2'd0, PROCESS = 2'd1, DONE = 2'd2;

    reg signed [WIDTH-1:0] x, y, z;
    reg [4:0] i;
    reg [1:0] state;

    reg signed [WIDTH-1:0] atan_table [0:15];
    initial begin
        atan_table[ 0] = 32'sd25736;
        atan_table[ 1] = 32'sd15192;
        atan_table[ 2] = 32'sd8027;
        atan_table[ 3] = 32'sd4074;
        atan_table[ 4] = 32'sd2045;
        atan_table[ 5] = 32'sd1023;
        atan_table[ 6] = 32'sd511;
        atan_table[ 7] = 32'sd256;
        atan_table[ 8] = 32'sd128;
        atan_table[ 9] = 32'sd64;
        atan_table[10] = 32'sd32;
        atan_table[11] = 32'sd16;
        atan_table[12] = 32'sd8;
        atan_table[13] = 32'sd4;
        atan_table[14] = 32'sd2;
        atan_table[15] = 32'sd1;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            done <= 0;
            x <= 0; y <= 0; z <= 0;
            x_out <= 0; y_out <= 0; z_out <= 0;
            i <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 0;
                    if (start) begin
                        x <= mode ? x_in : K;
                        y <= mode ? y_in : 0;
                        z <= mode ? 0 : z_in;
                        i <= 0;
                        state <= PROCESS;
                    end
                end
                
                PROCESS: begin
                    if (i < ITER) begin
                        if ((mode == 0 && z >= 0) || (mode == 1 && y < 0)) begin
                            x <= x - (y >>> i);
                            y <= y + (x >>> i);
                            z <= z - atan_table[i];
                        end else begin
                            x <= x + (y >>> i);
                            y <= y - (x >>> i);
                            z <= z + atan_table[i];
                        end
                        i <= i + 1;
                    end else begin
                        x_out <= x;
                        y_out <= y;
                        z_out <= z;
                        done <= 1;
                        state <= DONE;
                    end
                end
                
                DONE: begin
                    // Stay here holding outputs until next start
                    done <= 0;     // Clear done for new operation
                    state <= IDLE;  // Return to IDLE to restart
                end
            endcase
        end
    end
endmodule