`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2020 11:13:13 AM
// Design Name: 
// Module Name: poly_stage
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


module poly_stage
#(BITS=16, PRECISION="HALF", N = 2, STAGE = 0)
(
input clk,
input in_valid,
input [BITS-1:0] coef_in[N],
input [BITS-1:0] xin,
input [BITS-1:0] yin,
output out_valid,
output [BITS-1:0] coef_out[N],
output [BITS-1:0] xout,
output [BITS-1:0] yout
);

logic [BITS-1:0] add_out;
logic [BITS-1:0] x[3] = '{ default : 0 };
logic [BITS-1:0] y[3] = '{ default : 0 };
logic [BITS-1:0] coef[3][N] = '{ default : 0 };
logic out_valid_add;

always @(posedge clk)
  begin
    x[0] <= xin;
    for (int i = 1; i < 3; i++)
      x[i] <= x[i-1];
  end
  
always @(posedge clk)
  begin
    y[0] <= yin;
    for (int i = 1; i < 3; i++)
      y[i] <= y[i-1];
  end

always @(posedge clk)
  begin
    coef[0] <= coef_in;
    for (int i = 1; i < 3; i++)
      coef[i] <= coef[i-1];
  end

assign  xout = x[2];
assign coef_out = coef[2];

add
#(.BITS(BITS), .PRECISION(PRECISION))
add1
(
.rstn(1'b1),
.clk,
.in_valid(in_valid),
.a(coef_in[STAGE]),
.b(yin),
.out_valid(out_valid_add),
.c(add_out)
);

multiply
#(.BITS(BITS), .PRECISION(PRECISION))
multiply1
(
.rstn(1'b1),
.clk,
.in_valid(out_valid_add),
.a(add_out),
.b(x[0]),
.out_valid(out_valid),
.c(yout)
);

endmodule
