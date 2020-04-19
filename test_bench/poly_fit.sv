`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2020 07:21:15 AM
// Design Name: 
// Module Name: poly_fit
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

module poly_fit
#(N = 10, DEGREE = 5)
(
input real x[N],
input real y[N],
output real coef[DEGREE+1]
);

localparam COEFS = DEGREE+1;

typedef real coef_t[COEFS];
typedef real r_t[COEFS][COEFS];
typedef real q_t[N][COEFS];
typedef real q_transpose_t[COEFS][N];

always_comb
  coef = CalcCoef();

function coef_t CalcCoef();
coef_t coef;
 //% Construct Vandermonde matrix.
 q_t V;
 q_t Q;
 r_t R;
 for (int i = 0; i < N; i++)
   V[i][DEGREE] = 1;
 for (int j = DEGREE-1; j >= 0; j--)
   for (int k = 0; k < N; k++)
     V[k][j] = x[k] * V[k][j + 1];

  //% Solve least squares problem.
  CalcQR(V, Q, R);
  // FIXME ws = warning('off','all');
  // FIXME p = R\(Q'*y);    % Same as p = V\y;
  SolveTriangular(R, Multiply(Transpose(Q), y), coef);
  return coef;
endfunction

function real Hypot(real a, real b);
  return sqrt(pow(a, 2) + pow(b, 2));
endfunction

function void Setup(input q_t matrix, 
                    output q_t QR,
                    output coef_t Rdiag);
  real nrm;
  // Initialize.
  for (int i = 0; i < N; i++)
    for (int j = 0; j < COEFS; j++)
      QR[i][j] = matrix[i][j];
  Rdiag = '{ default : 0 };

  // Main loop.
  for (int k = 0; k < COEFS; k++)
    begin
      // Compute 2-norm of k-th column without under/overflow.
      nrm = 0;
      for (int i = k; i < N; i++)
        nrm = Hypot(nrm, QR[i][k]);
      if (nrm != 0.0)
        begin
          // Form k-th Householder vector.
          if (QR[k][k] < 0)
            nrm = -nrm;
          for (int i = k; i < N; i++)
            QR[i][k] /= nrm;
          QR[k][k] += 1.0;

          // Apply transformation to remaining columns.
          for (int j = k + 1; j < COEFS; j++)
            begin
              real s;
              s = 0.0;
              for (int i = k; i < N; i++)
                s += QR[i][k] * QR[i][j];
              s = (-s) / QR[k][k];
              for (int i = k; i < N; i++)
                QR[i][j] += s * QR[i][k];
            end
        end
    Rdiag[k] = -nrm;
    end
endfunction

function void CalcQ(input real QR[N][COEFS], 
                    output real Q[N][COEFS]);
  Q = '{ default : 0 };
  for (int k = COEFS - 1; k >= 0; k--)
    begin
      for (int i = 0; i < N; i++)
        Q[i][k] = 0.0;
      Q[k][k] = 1.0;
      for (int j = k; j < COEFS; j++)
        begin
          if (QR[k][k] != 0)
            begin
              real s;
              s = 0.0;
              for (int i = k; i < N; i++)
                s += QR[i][k] * Q[i][j];
              s = (-s) / QR[k][k];
              for (int i = k; i < N; i++)
                Q[i][j] += s * QR[i][k];
            end
        end
    end
endfunction  

function void CalcR(input real QR[N][COEFS], 
                    input real Rdiag[COEFS],
                    output r_t R);
  R = '{default : 0 };
  for (int i = 0; i < COEFS; i++)
    begin
      for (int j = 0; j < COEFS; j++)
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

function void CalcQR(input real V[N][COEFS], 
                    output real Q[N][COEFS],
                    output r_t R);
  real QR[N][COEFS];
  real Rdiag[COEFS];
  Setup(V, QR, Rdiag);
  CalcQ(QR, Q);
  CalcR(QR, Rdiag, R);
endfunction

function void SolveTriangular(input r_t M, input coef_t b, output coef_t coef); 
  coef = '{ default : 0 };
  for (int i = COEFS-1; i >= 0; i--)
    begin
      real sum;
      sum = 0;
      for (int j = COEFS - 1; j >= i; j--)
        begin
          if (j > i)
            sum += M[i][j] * coef[j];
          else
            coef[i] = (b[i] - sum) / M[i][i];
        end
    end
endfunction

function q_transpose_t Transpose(q_t M);
  q_transpose_t result;
  for (int i = 0; i < COEFS; i++)
    for (int j = 0; j < N; j++)
      result[i][j] = M[j][i];
  return result;
endfunction

function coef_t Multiply(input q_transpose_t M, input real V[N]);
   coef_t result;
   for (int i = 0; i < COEFS; i++)
     result[i] = Dot(M[i], V);
   return result;
endfunction

function real Dot(real V1[N], real V2[N]);
  real result;
  result = 0;
  for (int i = 0; i < N; i++)
    result += V1[i] * V2[i];
  return result;
endfunction

endmodule
