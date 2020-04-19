`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2020 08:52:15 AM
// Design Name: 
// Module Name: solve_triangular_tb
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


module solve_triangular_tb();

parameter N = 3;

logic clk;
logic in_valid;
real M[N][N];
real b[N];
logic out_valid;
real x[N];

task Test(real Min[N][N], real bin[N]);
  in_valid <= 1;
  for (int i = 0; i < N; i++)
    begin
      b[i]<= bin[i];
      for (int j = 0; j < N; j++)
        M[i][j] <= Min[i][j];
    end
  @(posedge clk);
  in_valid <= 0;
  M <= '{ default : 0 };
  b <= '{ default : 0 };
endtask

real M1[][] = '{'{1.0, 2.0, 3.0}, '{0.0, 4.0, 5.0}, '{0.0, 0.0, 6.0}};
real b1[] = '{ 10, 20, 30 };

initial
  begin
    in_valid <= 0;
    M <= '{ default : 0 };
    b <= '{ default : 0 };
    @(posedge clk);
    Test(M1, b1);
    @(posedge clk);
    $stop;
  end

initial
  begin
    clk = 0;
    forever #10 clk = ~clk;
  end

solve_triangular
#(.N(N))
solve_triangular1
(
.clk,
.in_valid,
.M,
.b,
.out_valid,
.x
);

endmodule
