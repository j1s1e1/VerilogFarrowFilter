`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2020 11:38:23 AM
// Design Name: 
// Module Name: fractional_offset
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


module fractional_offset
#(BITS=16, PRECISION="HALF", logic [BITS-1:0] STEP = 0)
(
//input clkIn, // Probably need this for real calculation
input clkOut,
output logic [BITS-1:0] t = 0
);

logic [BITS-1:0] tout = 0;
logic [BITS-1:0] tout_d = 0;
logic [BITS-1:0] tout_int = 0;
logic [BITS-1:0] tout_frac = 0;

always @(posedge clkOut)
  tout_d <= tout;
  
always @(posedge clkOut)
  t <= tout_frac;

add
#(.BITS(BITS), .PRECISION(PRECISION))
add1
(
.rstn(1'b1),
.clk(clkOut),
.in_valid(1'b1),
.a(tout),
.b(STEP),
.out_valid(),
.c(tout)
);

integer_part
#(.BITS(BITS), .PRECISION(PRECISION))
integer_part1
(
.rstn(1'b1),
.clk(clkOut),
.in_valid(1'b1),
.a(tout),
.out_valid(),
.c(tout_int)
);

subtract
#(.BITS(BITS), .PRECISION(PRECISION))
subtract1
(
.rstn(1'b1),
.clk(clkOut),
.in_valid(1'b1),
.a(tout_d),
.b(tout_int),
.out_valid(),
.c(tout_frac)
);

endmodule
