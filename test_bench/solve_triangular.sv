`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2020 08:42:50 AM
// Design Name: 
// Module Name: solve_triangular
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


module solve_triangular
#(N = 3)
(
input clk,
input in_valid,
input real M[N][N],
input real b[N],
output logic out_valid,
output real x[N]
);

typedef real x_t[N];

always @(posedge clk)
  if (in_valid)
    out_valid <= 1;
  else
    out_valid <= 0;
   
always @(posedge clk)
  if (in_valid)
    CalcX();
  else
    x <= '{ default : 0};
    
function void CalcX(); 
  x = '{ default : 0 };
  for (int i = N-1; i >= 0; i--)
    begin
      real sum;
      sum = 0;
      for (int j = N - 1; j >= i; j--)
        begin
          if (j > i)
            sum += M[i][j] * x[j];
          else
            x[i] = (b[i] - sum) / M[i][i];
        end
    end
endfunction

endmodule
