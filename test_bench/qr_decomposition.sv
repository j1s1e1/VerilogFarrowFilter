`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2020 07:38:16 AM
// Design Name: 
// Module Name: qr_decomposition
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

// QR decomposition only works for a square matrix or M > N
// This routine does not check these values
module qr_decomposition
#(M = 3, N = 3)
(
input clk,
input in_valid,
input real matrix[M][N],
output logic out_valid,
output real Q[M][N],
output real R[N][N]
);

typedef real q_t[M][N];
typedef real r_t[N][N];

real QR[M][N];
real Rdiag[N];

always @(posedge clk)
  if (in_valid)
    out_valid <= 1;
  else
    out_valid <= 0;
    
always @(posedge clk)
  if (in_valid)
    CalcQR();
  else
    begin
      Q <= '{ default : 0};
      R <= '{ default : 0};
    end
    
function real Hypot(real a, real b);
  return sqrt(pow(a, 2) + pow(b, 2));
endfunction

function void Setup();
  real nrm;
  // Initialize.
  for (int i = 0; i < M; i++)
    for (int j = 0; j < N; j++)
      QR[i][j] = matrix[i][j];
  Rdiag = '{ default : 0 };

  // Main loop.
  for (int k = 0; k < N; k++)
    begin
      // Compute 2-norm of k-th column without under/overflow.
      nrm = 0;
      for (int i = k; i < M; i++)
        nrm = Hypot(nrm, QR[i][k]);
      if (nrm != 0.0)
        begin
          // Form k-th Householder vector.
          if (QR[k][k] < 0)
            nrm = -nrm;
          for (int i = k; i < M; i++)
            QR[i][k] /= nrm;
          QR[k][k] += 1.0;

          // Apply transformation to remaining columns.
          for (int j = k + 1; j < N; j++)
            begin
              real s;
              s = 0.0;
              for (int i = k; i < M; i++)
                s += QR[i][k] * QR[i][j];
              s = (-s) / QR[k][k];
              for (int i = k; i < M; i++)
                QR[i][j] += s * QR[i][k];
            end
        end
    Rdiag[k] = -nrm;
    end
endfunction

function void CalcQ();
  Q = '{ default : 0 };
  for (int k = N - 1; k >= 0; k--)
    begin
      for (int i = 0; i < M; i++)
        Q[i][k] = 0.0;
      Q[k][k] = 1.0;
      for (int j = k; j < N; j++)
        begin
          if (QR[k][k] != 0)
            begin
              real s;
              s = 0.0;
              for (int i = k; i < M; i++)
                s += QR[i][k] * Q[i][j];
              s = (-s) / QR[k][k];
              for (int i = k; i < M; i++)
                Q[i][j] += s * QR[i][k];
            end
        end
    end
endfunction  

function void CalcR();
  R = '{default : 0 };
  for (int i = 0; i < N; i++)
    begin
      for (int j = 0; j < N; j++)
        begin
            if (i < j)
              R[i][j] = QR[i][j];
            else if (i == j)
              R[i][j] = Rdiag[i];
            else
              R[i][j] = 0.0;
        end
    end
endfunction    

function void CalcQR();
  Setup();
  CalcQ();
  CalcR();
endfunction

endmodule
