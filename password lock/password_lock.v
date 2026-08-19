module password_lock (
    input        clk,
    input        reset,
    input        enter,
    input  [3:0] key,
    output reg   unlocked,
    output reg   alarm
);

    // Password = 1, 2, 3, 4
    parameter P1 = 4'd1;
    parameter P2 = 4'd2;
    parameter P3 = 4'd3;
    parameter P4 = 4'd4;

    // FSM states
    parameter S0 = 3'b000;
    parameter S1 = 3'b001;
    parameter S2 = 3'b010;
    parameter S3 = 3'b011;
    parameter OPEN = 3'b100;
    parameter ERROR = 3'b101;

    reg [2:0] state;
    reg [2:0] next_state;

    // State register
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Next-state logic
    always @(*) begin

        next_state = state;

        case (state)

            // Waiting for first digit
            S0: begin
                if (enter) begin
                    if (key == P1)
                        next_state = S1;
                    else
                        next_state = ERROR;
                end
            end

            // Waiting for second digit
            S1: begin
                if (enter) begin
                    if (key == P2)
                        next_state = S2;
                    else
                        next_state = ERROR;
                end
            end

            // Waiting for third digit
            S2: begin
                if (enter) begin
                    if (key == P3)
                        next_state = S3;
                    else
                        next_state = ERROR;
                end
            end

            // Waiting for fourth digit
            S3: begin
                if (enter) begin
                    if (key == P4)
                        next_state = OPEN;
                    else
                        next_state = ERROR;
                end
            end

            // Correct password
            OPEN: begin
                next_state = OPEN;
            end

            // Wrong password
            ERROR: begin
                next_state = ERROR;
            end

            default:
                next_state = S0;

        endcase
    end

    // Output logic
    always @(*) begin

        unlocked = 1'b0;
        alarm    = 1'b0;

        if (state == OPEN)
            unlocked = 1'b1;

        if (state == ERROR)
            alarm = 1'b1;

    end

endmodule
