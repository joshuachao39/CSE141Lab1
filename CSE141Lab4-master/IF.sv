// Design Name:    basic_proc
// Module Name:    IF 
// Project Name: 
// Description: 
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
module IF(
  input Branch_abs, // we only support absolute jumps			   
  input [15:0] Target,
  input Init,
  input Halt,
  input CLK,
  output logic[15:0] PC
  );
	 
  always_ff @(posedge CLK)
	if(Init)
	  PC <= 0;
	else if(Halt)
	  PC <= PC;
	else if(Branch_abs)	      // unconditional absolute jump
	  PC <= Target;
	else
	  PC <= PC+1;		  // default increment

endmodule
