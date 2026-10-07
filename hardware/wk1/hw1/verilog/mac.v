// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac (out, A, B, format, acc, clk, reset);

parameter bw = 8;
parameter psum_bw = 16;

input clk;
input acc;
input reset;
input format;

input signed [bw-1:0] A;
input signed [bw-1:0] B;

output signed [psum_bw-1:0] out;

reg signed [psum_bw-1:0] psum_q;
reg signed [bw-1:0] a_q;
reg signed [bw-1:0] b_q;

assign out = psum_q;

// Your code goes here

reg signed [psum_bw-1:0] psum_out;

// Input
always @(posedge clk) begin
    if (reset == 1'b1) begin
        a_q <= 0;
        b_q <= 0;
    end
    else begin
        if (format == 1'b0) begin
            // 2's complement
            a_q <= A;
            b_q <= B;
        end
        else begin
            // Signed magnitude
            a_q <= A[bw-1] ? -A[bw-2:0] : A[bw-2:0];
            b_q <= B[bw-1] ? -B[bw-2:0] : B[bw-2:0];
        end
    end
end

// MAC
always @(posedge clk) begin
    if (reset == 1'b1) begin
        psum_out <= 0;
    end
    else begin
        if (acc == 1'b0)
            psum_out <= a_q * b_q;
        else
            psum_out <= psum_out + a_q * b_q;
    end
end

// Convert internal result
always @(*) begin
    if (format == 1'b0) begin
        // 2's complement
        psum_q = psum_out;
    end
    else begin
        // Signed magnitude
        if (psum_out < 0)
            psum_q = {1'b1, -psum_out[psum_bw-2:0]};
        else
            psum_q = {1'b0, psum_out[psum_bw-2:0]};
    end
end

endmodule