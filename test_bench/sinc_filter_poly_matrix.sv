`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2020 10:22:54 AM
// Design Name: 
// Module Name: sinc_filter_poly_matrix
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


module sinc_filter_poly_matrix
#(FILTERS=40, TAPS=6, SPAN=6, DEGREE=4)
(
output real polyM[DEGREE+1][TAPS]
);

localparam COEFS = DEGREE+1;

typedef real M_t[FILTERS][TAPS];
typedef real polyM_t[COEFS][TAPS];

real M[FILTERS][TAPS];
real x[FILTERS];
real y[FILTERS];
real coef[COEFS];

for (genvar g = 0; g < FILTERS; g++)
  assign x[g] = (1.0 * g)/FILTERS;
    
always_comb
  SincFilterPolyMatrix(M, polyM);

task SincFilterPolyMatrix(input M_t M, output polyM_t polyM);
  for (int i = 0; i < TAPS; i++)
    begin
      for (int j = 0; j < FILTERS; j++)
        y[j] = M[j][i];
      #1;
      for (int j = 0; j < COEFS; j++)
        polyM[j][i] = coef[j];
    end
endtask

poly_fit
#(.N(FILTERS), .DEGREE(DEGREE))
poly_fit1
(
.x,
.y,
.coef
);

sinc_filter_matrix
#(.FILTERS(FILTERS), .TAPS(TAPS), .SPAN(SPAN))
sinc_filter_matrix1
(
.M
);

endmodule
