`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2020 11:21:17 AM
// Design Name: 
// Module Name: systolic_fir
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


module systolic_fir
#(BITS=16, PRECISION="HALF", N = 3)
(
input clk,
input [BITS-1:0] coef[N],
input [BITS-1:0] xin,
output [BITS-1:0] yout
);

logic [BITS-1:0] x[N+1];
logic [BITS-1:0] y[N+1];

assign x[0] = xin;
assign y[0] = 0;
assign yout = y[N];

for (genvar g = 0; g < N; g++)
fir_tap
#(.BITS(BITS), .PRECISION(PRECISION))
fir_tap_array
(
.clk,
.coef(coef[g]),
.xin(x[g]),
.yin(y[g]),
.xout(x[g+1]),
.yout(y[g+1])
);

endmodule
