`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2020 02:40:55 PM
// Design Name: 
// Module Name: systolic_poly_tb
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


module systolic_poly_tb();

parameter BITS=32, PRECISION="SINGLE", N = 6;

logic clk;
logic in_valid;
logic [BITS-1:0] coef[N];
logic [BITS-1:0] xin;
logic out_valid;
logic [BITS-1:0] yout;

task Test(real coef_in[N], real x);
  in_valid <= 1;
  for (int i = 0; i < N; i++)
    coef[i] <= $shortrealtobits(coef_in[i]);
  xin <= $shortrealtobits(x);
  @(posedge clk);
  in_valid <= 0;
  xin <= 0;
  coef <= '{ default : 0 };
endtask

real coef1[] = '{-0.0881473124027252,-0.41703188419342,1.15746092796326,-0.124283373355865,0.471328258514404,4.00360774993896};

initial
  begin
    in_valid <= 0; 
    coef <= '{default : 0};
    xin <= 0;
    @(posedge clk);
    Test(coef1, 0);
    @(posedge clk);
    Test(coef1, 0.25);
    @(posedge clk);
    @(posedge clk);
    Test(coef1, 0.5);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    Test(coef1, 0.75);
    @(posedge clk);
    repeat(20) @(posedge clk);
    $stop;
  end

initial
  begin
    clk = 0;
    forever #10 clk = ~clk;
  end

systolic_poly
#(.BITS(BITS), .PRECISION(PRECISION), .N(N))
systolic_poly1
(
.clk,
.in_valid,
.coef,
.xin,
.out_valid,
.yout
);

endmodule
