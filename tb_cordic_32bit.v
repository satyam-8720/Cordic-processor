
`timescale 1ns/1ps

module tb_cordic;

    reg clk = 0;
    reg rst = 0;
    reg start = 0;
    reg mode = 0;

    reg signed [31:0] x_in, y_in, z_in;
    wire signed [31:0] x_out, y_out, z_out;
    wire done;

    localparam signed [31:0] PI_FIXED = 32'sd102944;  // π ≈ 3.1416 * 32768

    cordic uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .mode(mode),
        .x_in(x_in),
        .y_in(y_in),
        .z_in(z_in),
        .x_out(x_out),
        .y_out(y_out),
        .z_out(z_out),
        .done(done)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("cordic_32bit.vcd");
        $dumpvars(0, tb_cordic);

        rst = 1; #10; rst = 0;

        // Test rotation mode for z = π/4
        mode = 0;
        x_in = 0;
        y_in = 0;
        z_in = PI_FIXED >>>2; // π/4
        start = 1; #10; start = 0;
        wait(done);
        $display("Rotation Mode:");
        $display("z_in = %d", z_in);
        $display("cos = %d, sin = %d", x_out, y_out);
        $display("cos = %f, sin = %f", x_out / 32768.0, y_out / 32768.0);

        #50;

        // Test vectoring mode for x = y = 0.707
        mode = 1;
        x_in = 32'sd40960; //1.25
        y_in = 32'sd77005;//2.35
        z_in = 0;
        start = 1; #10; start = 0;
        wait(done);
        $display("Vectoring Mode:");
        $display("x_in = %d, y_in = %d", x_in, y_in);
        $display("magnitude = %d, angle = %d", x_out, z_out);
        $display("True magnitude = %f",x_out/53962.34);
        $display("angle in rad ≈ %f", z_out / 32768.0);

        #100;
        $finish;
    end

endmodule
