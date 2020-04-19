`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2020 09:33:02 AM
// Design Name: 
// Module Name: poly_fit_tb
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


module poly_fit_tb();

parameter N = 9, DEGREE = 4;

logic clk;
real x[N];
real y[N];
real coef[DEGREE+1];

real x1[] = '{ 9, 8, 7, 6, 5, 4, 3, 2, 1 };
real y1[] = '{ 1, 2, 3, 4, 5, 4, 3, 2, 1 };

task Test(real xin[], real yin[]);
  for (int i = 0; i < N; i++)
    begin
      x[i] <= xin[i];
      y[i] <= yin[i];
    end
  @(posedge clk);
  x <= '{ default : 0 };
  y <= '{ default : 0 };
endtask

initial
  begin
    x <= '{ default : 0 };
    y <= '{ default : 0 };
    @(posedge clk);
    Test(x1, y1);
    @(posedge clk);
    $stop;
  end

initial
  begin
    clk = 0;
    forever #10 clk = ~clk;
  end
  
poly_fit
#(.N(N), .DEGREE(DEGREE))
poly_fit1
(
.x,
.y,
.coef
);

endmodule
