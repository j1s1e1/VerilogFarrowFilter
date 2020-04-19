`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2020 11:10:03 AM
// Design Name: 
// Module Name: systolic_poly
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module systolic_poly
#(BITS=16, PRECISION="HALF", N = 3)
(
input clk,
input in_valid,
input logic [BITS-1:0] coef[N], // Modified for changing coefecients
input [BITS-1:0] xin,
output out_valid,
output [BITS-1:0] yout
);

logic [BITS-1:0] x[N+1];
logic [BITS-1:0] y[N+1];
logic [BITS-1:0] coef_in[N][N];
logic [BITS-1:0] coef_out[N][N];
logic in_valid_array[N];
logic out_valid_array[N-1];

assign coef_in[0] = coef;
for (genvar g = 1; g < N; g++)
  assign coef_in[g] = coef_out[g-1];

assign x[0] = xin;
assign y[0] = 0;
assign yout = (out_valid) ? y[N] : 0;

assign in_valid_array[0] = in_valid;
for (genvar g = 1; g < N; g++)
  assign in_valid_array[g] = out_valid_array[g-1];

for (genvar g = 0; g < N-1; g++)
poly_stage
#(.BITS(BITS), .PRECISION(PRECISION), .N(N), .STAGE(g))
poly_stage_array
(
.clk,
.in_valid(in_valid_array[g]),
.coef_in(coef_in[g]),
.xin(x[g]),
.yin(y[g]),
.out_valid(out_valid_array[g]),
.coef_out(coef_out[g]),
.xout(x[g+1]),
.yout(y[g+1])
);

add
#(.BITS(BITS), .PRECISION(PRECISION))
add1
(
.rstn(1'b1),
.clk,
.in_valid(in_valid_array[N-1]),
.a(coef_out[N-2][N-1]),
.b(y[N-1]),
.out_valid,
.c(y[N])
);

endmodule
