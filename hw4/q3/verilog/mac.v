// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac (out, x0, w0, x1, w1, x2, w2, x3, w3, in);

parameter bw = 4;
parameter psum_bw = 16;

input unsigned [bw-1:0] x0;
input unsigned [bw-1:0] x1;
input unsigned [bw-1:0] x2;
input unsigned [bw-1:0] x3;
input signed [bw-1:0] w0;
input signed [bw-1:0] w1;
input signed [bw-1:0] w2;
input signed [bw-1:0] w3;

input signed [psum_bw-1:0] in;

output signed [psum_bw-1:0] out;

wire signed [bw:0] x0_signed;
wire signed [bw:0] x1_signed;
wire signed [bw:0] x2_signed;
wire signed [bw:0] x3_signed;
wire signed [2*bw:0] product0;
wire signed [2*bw:0] product1;
wire signed [2*bw:0] product2;
wire signed [2*bw:0] product3;

wire signed [2*bw+1:0] internal_sum0;
wire signed [2*bw+1:0] internal_sum1;

assign x0_signed = $signed({1'b0, x0});
assign x1_signed = $signed({1'b0, x1});
assign x2_signed = $signed({1'b0, x2});
assign x3_signed = $signed({1'b0, x3});

assign product0 = x0_signed * w0;
assign product1 = x1_signed * w1;
assign product2 = x2_signed * w2;
assign product3 = x3_signed * w3;

assign internal_sum0 = product0 + product1;
assign internal_sum1 = product2 + product3;

assign out = internal_sum0 + internal_sum1 + in;

endmodule
