// Create Date:    2016.10.15
// Module Name:    ALU 
// Project Name: 
// Dependencies: 
//
// Revision 0.01 - File Created
// Additional Comments: 
//   combinational (unclocked) ALU
import definitions::*;			  // includes package "definitions"
module ALU(
  input [7:0] INPUTA,      	  // rs
              INPUTB,             // rt
              IMMEDIATE,
  input       SC_IN,              // carry in
  input [4:0] OP,	          // ALU opcode, part of microcode
  output logic [7:0] OUT,         // or:  output reg [7:0] OUT,
  output logic branch,
  output logic SC_OUT
);
	 
  op_mne op_mnemonic;			  // type enum: used for convenient waveform viewing 
	
  always_comb begin
    {SC_OUT, OUT} = 0;
    branch = 'b0;
    case(OP)
	oXOR: OUT = INPUTA ^ INPUTB;
	oXORALL: OUT = INPUTA[0] ^ INPUTA[1] ^ INPUTA[2] ^ INPUTA[3] ^ INPUTA[4] ^ INPUTA[5] ^ INPUTA[6] ^ INPUTA[7];
	oAND: OUT = INPUTA & INPUTB;
	oOR: OUT = INPUTA | INPUTB;
	oSLL: OUT = INPUTA << IMMEDIATE;
	oSRL: OUT = INPUTA >> IMMEDIATE;
	oSHLD: begin
            //OUT = INPUTA << IMMEDIATE;
            //OUT[0 +: IMMEDIATE] = INPUTB[7 -: IMMEDIATE]; // not sure if this is the case
	    OUT = 'd0;
        end
	oSHRD: begin
            //OUT = INPUTA >> IMMEDIATE;
            //OUT[7:8-IMMEDIATE] = INPUTB[IMMEDIATE-1:0]; // not sure if this is the case
            OUT = 'd0;
        end
	oADD: OUT = INPUTA + INPUTB;
        oADDACROSS: {SC_OUT, OUT} = {1'b0, INPUTA} + IMMEDIATE + SC_IN;
        oGETPARITY: OUT = 'd0; // TODO
	oMEM: OUT = INPUTA + IMMEDIATE;
	oXORI: OUT = INPUTA ^ IMMEDIATE;
	oANDI: OUT = INPUTA & IMMEDIATE;
	oADDI: OUT = INPUTA + IMMEDIATE;
	oBNE: begin
            if (INPUTA != INPUTB) begin
                branch = 'b1;
            end
        end
	oBEQ: begin
            if (INPUTA == INPUTB) begin
                branch = 'b1;
            end
        end
	oBGE: begin
            if (INPUTA >= INPUTB) begin
                branch = 'b1;
            end
        end
	oBLT: begin
            if (INPUTA < INPUTB) begin
                branch = 'b1;
            end
        end
	oBLE: begin
            if (INPUTA <= INPUTB) begin
                branch = 'b1;
	    end
        end
	default: {SC_OUT, OUT} = 0;
    endcase
  display("ALU Out %d \n",OUT);
  op_mnemonic = op_mne'(OP);
  end






/*
// single instruction for both LSW & MSW
  case(OP)
    kADD : {SC_OUT, OUT} = {1'b0,INPUTA} + INPUTB + SC_IN;    // add w/ carry-in & out
    kLSH : {SC_OUT, OUT} = {INPUTA, SC_IN};  	       // shift left 
    kRSH : {OUT, SC_OUT} = {SC_IN, INPUTA};			   // shift right
//  kRSH : {OUT, SC_OUT} = (INPUTA << 1'b1) | SC_IN;
    kXOR : begin 
        OUT = INPUTA^INPUTB;  				   // exclusive OR
	SC_OUT = 0;							   // possible convenience
	end
    kAND : begin                                       // bitwise AND
        OUT = INPUTA & INPUTB;
	SC_OUT = 0;
        end
    kSUB : begin
	OUT = INPUTA + (~INPUTB) + SC_IN;	   // check me on this!
	SC_OUT = 0;                               // check me on this!
    end
    default: {SC_OUT,OUT} = 0;						   // no-op, zero out
  endcase
// option 2 -- separate LSW and MSW instructions
//    case(OP)
//	  kADDL : {SC_OUT,OUT} = INPUTA + INPUTB ;    // LSW add operation
//	  kLSAL : {SC_OUT,OUT} = (INPUTA<<1) ;  	  // LSW shift instruction
//	  kADDU : begin
//	            OUT = INPUTA + INPUTB + SC_IN;    // MSW add operation
//                SC_OUT = 0;   
//              end
//	  kLSAU : begin
//	            OUT = (INPUTA<<1) + SC_IN;  	  // MSW shift instruction
//                SC_OUT = 0;
//               end
//      kXOR  : OUT = INPUTA ^ INPUTB;
//	  kBRNE : OUT = INPUTA - INPUTB;   // use in conjunction w/ instruction decode 
//  endcase
	case(OUT)
	  'b0     : ZERO = 1'b1;
	  default : ZERO = 1'b0;
	endcase
//$display("ALU Out %d \n",OUT);
    op_mnemonic = op_mne'(OP);
  end
  always_comb BEVEN = //opcode[8:6] 
       OP == 3'b101; //!INPUTB[0];               // note [0] -- look at LSB only
// always_comb	branch_enable = opcode[8:6]==3'b101? 1 : 0;  
*/
endmodule



	   /*
			Left shift

            
			  input a = 10110011   sc_in = 1

              output = 01100111
			  sc_out =	1

							   */