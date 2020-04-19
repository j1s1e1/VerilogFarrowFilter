`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2020 06:50:18 AM
// Design Name: 
// Module Name: sinc_filter_matrix
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

module sinc_filter_matrix
#(FILTERS=40, TAPS=6, SPAN=6)
(
output real M[FILTERS][TAPS]
);

assign M = CalcM();

typedef real m_t[FILTERS][TAPS];

function m_t CalcM();
  real pulseWidth;
  int points;
  real step;
  real current;
  int filter;
  int tap;
  pulseWidth = PI * SPAN;
  points = FILTERS * TAPS;
  if (TAPS[0]== 0)
    begin
     step = pulseWidth / (points - 1);
     current = -pulseWidth / 2.0;
     filter = 0;
     tap = 0;
     for (int i = 0; i < points; i++)
       begin
         CalcM[filter][tap] = sinc(current);
         filter++;
         current += step;
         if (filter == FILTERS)
           begin
             filter = 0;
             tap++;
           end
       end
    end
    else
      begin
        $display("odd tap count not currently implemented");
      end
endfunction

endmodule
