`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2020 04:43:57 PM
// Design Name: 
// Module Name: farrow_glitch_tb
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

import math_pkg::*;

module farrow_glitch_tb();

parameter BITS=32, PRECISION="SINGLE", DEGREE = 5, TAPS = 12;
parameter [BITS-1:0] STEP = $shortrealtobits(3.0/7.0);
parameter SPAN = TAPS;
parameter FILTERS = 40;

logic clkIn;
logic in_valid;
logic [BITS-1:0] x;
logic [BITS-1:0] polyM[DEGREE+1][TAPS]; // Typically could be parameter.  Using logic to allow calcs in TB
logic clkOut;
logic out_valid;
logic [BITS-1:0] y;

task Test(real xin[]);
  in_valid <= 1;
  for (int i = 0; i < xin.size(); i++)
    begin
      x <= $shortrealtobits(xin[i]);
      @(posedge clkIn);
    end
  in_valid <= 0;
  x <= 0;
endtask

task Sin(int cycles, real step);
  real x[];
  int steps;
  steps = (cycles * PI / step);
  x = new[2 * steps + 1];
  for (int i = -steps; i <= steps; i++)
    x[steps + i] = sin(i * step);
  Test(x);
endtask

real x1[] = '{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 8, 7, 6, 5, 4, 3, 2, 1 };


initial
  begin
    in_valid <= 0;
    x <= 0;
    @(posedge clkIn);
    Test(x1);
    @(posedge clkIn);
    repeat(10) @(posedge clkIn);
    Sin(10, 0.65);
    repeat (50) @(posedge clkIn);
    $stop;
  end

initial
  begin
    clkIn = 0;
    repeat(1) @(posedge clkOut);
    forever #70 clkIn = ~clkIn;
  end

initial
  begin
    clkOut = 0;
    forever #30 clkOut = ~clkOut;
  end

farrow
#(.BITS(BITS), .PRECISION(PRECISION), .DEGREE(DEGREE), .TAPS(TAPS), .STEP(STEP))
farrow1
(
.clkIn,
.in_valid,
.x,
.polyM, // Typically could be parameter.  Using logic to allow calcs in TB
.clkOut,
.out_valid,
.y
);

real polyM_real[DEGREE+1][TAPS];

for (genvar g = 0; g < DEGREE+1; g++)
  for (genvar h = 0; h < TAPS; h++)
    assign polyM[g][h] = $shortrealtobits(polyM_real[g][h]);

sinc_filter_poly_matrix
#(.FILTERS(FILTERS), .TAPS(TAPS), .SPAN(SPAN), .DEGREE(DEGREE))
sinc_filter_poly_matrix1
(
.polyM(polyM_real)
);

endmodule
