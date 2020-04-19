`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2020 08:06:55 AM
// Design Name: 
// Module Name: qr_decomposition_tb
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


module qr_decomposition_tb();

parameter M = 3, N = 3;

logic clk;
logic in_valid;
real matrix[M][N];
logic out_valid;
real Q[M][N];
real R[N][N];

task Test(real matrix_in[M][N]);
  in_valid <= 1;
  for (int i = 0; i < M; i++)
    for (int j = 0; j < N; j++)
      matrix[i][j] <= matrix_in[i][j];
  @(posedge clk);
  in_valid <= 0;
  matrix <= '{ default : 0 };
endtask

real M1[][] = '{'{1.0, 2.0, 3.0}, '{4.0, 5.0, 6.0}, '{7.0, 8.0, 9.0}};

initial
  begin
    in_valid <= 0;
    matrix <= '{ default : 0 };
    @(posedge clk);
    Test(M1);
    @(posedge clk);
    $stop;
  end

initial
  begin
    clk = 0;
    forever #10 clk = ~clk;
  end

qr_decomposition
#(.M(M), .N(N))
qr_decomposition1
(
.clk,
.in_valid,
.matrix,
.out_valid,
.Q,
.R
);

endmodule
