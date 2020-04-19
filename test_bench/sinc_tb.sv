`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2020 01:02:37 PM
// Design Name: 
// Module Name: sinc_tb
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

module sinc_tb();

initial
  begin
    $display("%f", sinc(PI));
    $display("%f", sinc(PI/2));
    $display("%f", sinc(-18.85));
    $stop;
  end
endmodule
