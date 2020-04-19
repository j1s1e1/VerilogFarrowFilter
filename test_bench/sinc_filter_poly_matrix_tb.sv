`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2020 10:44:42 AM
// Design Name: 
// Module Name: sinc_filter_poly_matrix_tb
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


module sinc_filter_poly_matrix_tb();

parameter FILTERS=40, TAPS=12, DEGREE=5;
parameter SPAN=TAPS;

real polyM[DEGREE+1][TAPS];

initial
  begin
    #10;
    #10;
    $stop;
  end
  
sinc_filter_poly_matrix
#(.FILTERS(FILTERS), .TAPS(TAPS), .SPAN(SPAN), .DEGREE(DEGREE))
sinc_filter_poly_matrix1
(
.polyM
);

endmodule
