`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2020 11:22:53 AM
// Design Name: 
// Module Name: fir_tap
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


module fir_tap
#(BITS=16, PRECISION="HALF")
(
input clk,
input [BITS-1:0] coef,
input [BITS-1:0] xin,
input [BITS-1:0] yin,
output [BITS-1:0] xout,
output [BITS-1:0] yout
);

logic [BITS-1:0] mult_out;
logic [BITS-1:0] x[3] = '{ default : 0 };
logic [BITS-1:0] y[3] = '{ default : 0 };

always @(posedge clk)
  begin
    y[0] <= yin;
    for (int i = 1; i < 3; i++)
      y[i] <= y[i-1];
  end

always @(posedge clk)
  begin
    x[0] <= xin;
    for (int i = 1; i < 3; i++)
      x[i] <= x[i-1];
  end

assign  xout = x[2];

multiply
#(.BITS(BITS), .PRECISION(PRECISION))
multiply1
(
.rstn(1'b1),
.clk,
.in_valid(1'b1),
.a(coef),
.b(xin),
.out_valid(),
.c(mult_out)
);

add
#(.BITS(BITS), .PRECISION(PRECISION))
add1
(
.rstn(1'b1),
.clk,
.in_valid(1'b1),
.a(y[2]),
.b(mult_out),
.out_valid(),
.c(yout)
);

endmodule
