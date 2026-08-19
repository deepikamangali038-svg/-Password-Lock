`timescale 1ns/1ps

module password_lock_tb;

    reg clk;
    reg reset;
    reg enter;
    reg [3:0] key;

    wire unlocked;
    wire alarm;

    password_lock DUT (
        .clk(clk),
        .reset(reset),
        .enter(enter),
        .key(key),
        .unlocked(unlocked),
        .alarm(alarm)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Enter a key
    task enter_key;
        input [3:0] digit;

        begin
            @(negedge clk);

            key = digit;
            enter = 1'b1;

            @(negedge clk);

            enter = 1'b0;
            key = 4'd0;
        end
    endtask

    initial begin

        clk   = 1'b0;
        reset = 1'b1;
        enter = 1'b0;
        key   = 4'd0;

        $display("======================================");
        $display("        PASSWORD LOCK TESTBENCH");
        $display("======================================");

        // Reset
        #10;
        reset = 1'b0;

        // --------------------------------
        // TEST 1: Correct password 1-2-3-4
        // --------------------------------

        $display("");
        $display("TEST 1: Enter correct password 1-2-3-4");

        enter_key(4'd1);
        enter_key(4'd2);
        enter_key(4'd3);
        enter_key(4'd4);

        #2;

        if (unlocked == 1'b1 && alarm == 1'b0)
            $display("PASS: Password correct - LOCK UNLOCKED");
        else
            $display("FAIL: Password should unlock");

        // --------------------------------
        // TEST 2: Wrong password
        // --------------------------------

        #10;

        reset = 1'b1;
        #10;
        reset = 1'b0;

        $display("");
        $display("TEST 2: Enter wrong password 1-2-3-5");

        enter_key(4'd1);
        enter_key(4'd2);
        enter_key(4'd3);
        enter_key(4'd5);

        #2;

        if (alarm == 1'b1 && unlocked == 1'b0)
            $display("PASS: Wrong password - ALARM ACTIVE");
        else
            $display("FAIL: Alarm should be active");

        // --------------------------------
        // TEST 3: Wrong first digit
        // --------------------------------

        #10;

        reset = 1'b1;
        #10;
        reset = 1'b0;

        $display("");
        $display("TEST 3: Enter wrong password 9-2-3-4");

        enter_key(4'd9);
        enter_key(4'd2);
        enter_key(4'd3);
        enter_key(4'd4);

        #2;

        if (alarm == 1'b1 && unlocked == 1'b0)
            $display("PASS: Wrong password - ALARM ACTIVE");
        else
            $display("FAIL: Alarm should be active");

        $display("");
        $display("======================================");
        $display("        ALL TESTS COMPLETED");
        $display("======================================");

        #10;
        $finish;

    end

endmodule
