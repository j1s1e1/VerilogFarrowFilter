`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2020 11:47:29 AM
// Design Name: 
// Module Name: fractional_offset_tb
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


module fractional_offset_tb();

parameter BITS=32, PRECISION="SINGLE";
parameter [BITS-1:0] STEP = $shortrealtobits(0.25);

logic clkIn;
logic clkOut;
logic [BITS-1:0] t;

initial
  begin
    repeat (10) @(posedge clkOut);
    $stop;
  end

initial
  begin
    clkOut = 0;
    forever #10 clkOut = ~clkOut;
  end

fractional_offset
#(.BITS(BITS), .PRECISION(PRECISION), .STEP(STEP))
fractional_offset1
(
//.clkIn,
.clkOut,
.t
);

endmodule
