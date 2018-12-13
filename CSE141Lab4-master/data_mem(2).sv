// Create Date:    2017.01.25
// Design Name:
// Module Name:    DataRAM
// single address pointer for both read and write
module data_mem(
  input              CLK,
  input              reset,
  input [7:0]        DataAddress,
  input              ReadMem,
  input              WriteMem,
  input [7:0]        DataIn,
  output logic[7:0]  DataOut);

  logic [7:0] my_memory [0:255];//[256];

//  initial 
//    $readmemh("dataram_init.list", my_memory);
  always_comb                     // reads are combinational
    if(ReadMem) begin
      DataOut = my_memory[DataAddress];
// optional diagnostic print
	  $display("Memory read M[%d] = %d",DataAddress,DataOut);
    end else 
      DataOut = 'bZ;           // tristate, undriven

  always_ff @ (posedge CLK)		 // writes are sequential
    if(reset) begin
// you may initialize your memory w/ constants, if you wish
      for(int i=0;i<256;i++)
	    my_memory[i] <= 0;
      my_memory[ 16] <= 254;   // overrides the 0
      my_memory[244] <= 5;
	end
    else if(WriteMem) begin
      my_memory[DataAddress] <= DataIn;
// optional diagnostic print statement
	  $display("Memory write M[%d] = %d",DataAddress,DataIn);
    end

endmodule
