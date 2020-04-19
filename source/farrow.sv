`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2020 01:47:44 AM
// Design Name: 
// Module Name: farrow
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


module farrow
#(BITS=16, PRECISION="HALF", DEGREE = 4, TAPS = 6, logic [BITS-1:0] STEP = 0)
(
input clkIn,
input in_valid,
input [BITS-1:0] x,
input [BITS-1:0] polyM[DEGREE+1][TAPS], // Typically could be parameter.  Using logic to allow calcs in TB
input clkOut,
output out_valid,
output [BITS-1:0] y
);

localparam COEFS = DEGREE+1;

logic [BITS-1:0] coef[COEFS][TAPS];
logic [BITS-1:0] farrow_coef[COEFS];
logic [BITS-1:0] t;

for (genvar g = 0; g < COEFS; g++)
  for (genvar h = 0; h < TAPS; h++)
    assign coef[g][h] = polyM[g][TAPS-1-h];

for (genvar g = 0; g < COEFS; g++)
systolic_fir
#(.BITS(BITS), .PRECISION(PRECISION), .N(TAPS))
systolic_fir_array
(
.clk(clkIn),
.coef(coef[g]),
.xin(x),
.yout(farrow_coef[g])
);

fractional_offset
#(.BITS(BITS), .PRECISION(PRECISION), .STEP(STEP))
fractional_offset1
(
//.clkIn,
.clkOut,
.t
);

systolic_poly
#(.BITS(BITS), .PRECISION(PRECISION), .N(COEFS))
systolic_poly1
(
.clk(clkOut),
.in_valid(1'b1),
.coef(farrow_coef),
.xin(t),
.out_valid,
.yout(y)
);

endmodule
