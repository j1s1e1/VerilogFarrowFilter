`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2020 07:05:18 AM
// Design Name: 
// Module Name: sinc_filter_matrix_tb
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


module sinc_filter_matrix_tb();

parameter FILTERS=40, TAPS=12;
parameter SPAN=TAPS;

real M[FILTERS][TAPS];

initial
  begin
    #10;
    $stop;
  end

sinc_filter_matrix
#(.FILTERS(FILTERS), .TAPS(TAPS), .SPAN(SPAN))
sinc_filter_matrix1
(
.M
);

endmodule
