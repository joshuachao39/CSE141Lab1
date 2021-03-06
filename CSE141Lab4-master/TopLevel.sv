// Create Date:    2018.04.05
// Design Name:    BasicProcessor
// Module Name:    TopLevel 
// partial only

/***********************
Joshua Chao
Ajeya Rengarajan
Rachel Teitelbaum

This is the top level module that combines all of the modules together to
actually implement the controller. Disclaimer: I actually have no fucking
clue about like half this shit, so I'm going to comment the crap out of this
in hopes that it'll eventually make sense. At a high level, we want our modules
to combine like the following:
                
PC -----> InstrROM ------> Ctrl --------> regFile -----> ALU -----> Memory

let's fucking do this

*************************/


										   
module TopLevel(
    input     start,	              // init/reset, active high
    input     clk,		      // clock -- posedge used inside design
    output    halt		      // done flag from DUT
    );

    logic[8:0]        instruction;      // 9-bit instruction code
    logic[15:0]       PC_target;       // where the PC should jump to

    logic[3:0]        rs_address;
    logic[3:0]        rt_address;
    logic[3:0]        rd_address;
    
    logic[7:0]        rs_data;         // Note that every value can be at most 8 bits large.
    logic[7:0]        rt_data;
    logic[7:0]        rd_data;

    logic[7:0]        ALU_data;        // FROM the ALU
    logic[7:0]        memory_data;     // FROM main memory
    logic[7:0]        immediate;       // FROM controller

    logic[4:0]        ALU_op;
    logic             isBranch;
    logic             regFile_isWrite;
    logic             memory_read;
    logic             memory_write;
    logic             isReadFromMemory;
    // logic[15:0] cycle_ct;	   // standalone; NOT PC!
    logic             carry_in;
    logic             carry_out;

    assign halt = (ALU_op == 31) ? 1 : 0;

    /*********************************
     INSTRUCTION FETCH SHOULD UPDATE THE PC BASED ON INPUTS
     inputs that actually matter:
         isBranch
         immediate

     outputs:
        PC_target
     *********************************/

    IF instructionFetch(
        .Branch_abs(isBranch),
        .Target(immediate),
	.Init(start),
        .Halt(halt),
        .CLK(clk),
	.PC(PC_target)
    );

    /***********************************
    INSTRUCTION MEMORY SHOULD GRAB THE CORRECT 9 BIT INSTR
    inputs that actually matter:
	PC_target
     outputs that actually matter:
	instruction
    ************************************/
    InstROM instr_ROM1(
	.InstAddress   (PC_target), 
	.InstOut       (instruction)
    );

    /************************************
    CONTROLLER SHOULD CONVERT 9 BIT INSTR INTO CORRECT SIGNALS
    inputs that actually matter:
	instruction
    outputs that actually matter:
	memory_read,
	memory_write,
	regFile_write,
	ALU_op,
	rs/rt/rd_address,
	immediate
    *************************************/
    Ctrl controller(
	.Instruction(instruction),
	.mem_read(memory_read),
	.mem_write(memory_write),
	.rf_write(regFile_isWrite),
	.aluOp(ALU_op),
	.rs_addr(rs_address),
	.rt_addr(rt_address),
	.rd_addr(rd_address),
	.imm(immediate)
    );

    /************************************
    REGISTER FILE SHOULD TAKE IN CORRECT ADDRESSES AND UPDATE AS NECESSARY
    inputs that actually matter:
	regFile_isWrite,
	rs/rt_address,
	rd_address,
	ALU_data,
	memory_data,
	isReadFromMemory
    outputs that actually matter:
	rs/rt_data,
    *************************************/
    reg_file registerFile(
	.CLK(clk),
	.write_en(regFile_isWrite),
	.raddrA(rs_address),
	.raddB(rt_address),
	.waddr(rd_address),
	.dataALU_in(ALU_data),
	.dataMem_in(memory_data),
	.data_source(isReadFromMemory),
	.data_outA(rs_data),
	.data_outB(rt_data)
    );

    /************************************
    ALU SHOULD JUST COMPUTE
    inputs that actually matter:
	rs/rt_data,
	immediate,
	ALU_op
    outputs that actually matter:
	ALU_data,
	branch
    *************************************/
    ALU alu(
	.INPUTA(rs_data),
	.INPUTB(rt_data),
	.IMMEDIATE(immediate),
	.SC_IN(carry_in),
	.OP(ALU_op),
	.OUT(ALU_data),
	.branch(isBranch),
	.SC_OUT(carry_out)
    );

   /*************************************
    MEMORY SHOULD WORK JUST AS EXPECTED
    inputs that actually matter:
	ALU_data,
	memory_read,
	memory_write,
	rt_data,
    outputs that actually matter:
	memory_data
    *************************************/
    data_mem memory(
	.CLK(clk),
	.reset(start),
	.DataAddress(ALU_data),
	.ReadMem(memory_read),
	.WriteMem(memory_write),
	.DataIn(rt_data),
	.DataOut(memory_data)
    );
	

/*
wire [ 9:0] PC;            // program count
wire [ 8:0] Instruction;   // our 9-bit opcode
wire [ 7:0] ReadA, ReadB;  // reg_file outputs
wire [ 7:0] InA, InB, 	   // ALU operand inputs
            ALU_out;       // ALU result
wire [ 7:0] regWriteValue, // data in to reg file
            memWriteValue, // data in to data_memory
	    Mem_Out;	   // data out from data_memory
wire        MEM_READ,	   // data_memory read enable
            MEM_WRITE,	   // data_memory write enable
	    reg_wr_en,	   // reg_file write enable
	    sc_clr,        // carry reg clear
	    sc_en,	       // carry reg enable
            SC_OUT,	       // to carry register
	    ZERO,		   // ALU output = 0 flag
	    BEVEN,		   // ALU input B is even flag
            jump_en,	   // to program counter: jump enable
            branch_en;	   // to program counter: branch enable
logic[15:0] cycle_ct;	   // standalone; NOT PC!
logic       SC_IN;         // carry register (loop with ALU)

// Fetch = Program Counter + Instruction ROM
// Program Counter
  PC PC1 (
	.init       (start), 
	.halt              ,  // SystemVerilg shorthand for .halt(halt), 
	.jump_en           ,  // jump enable
	.branch_en	       ,  // branch enable
	.CLK        (CLK)  ,  // (CLK) is required in Verilog, optional in SystemVerilog
	.PC             	  // program count = index to instruction memory
	);					  

// Control decoder
  Ctrl Ctrl1 (
	.Instruction,    // from instr_ROM
	.ZERO,			 // from ALU: result = 0
	.BEVEN,			 // from ALU: input B is even (LSB=0)
	.jump_en,		 // to PC
	.branch_en		 // to PC
  );
// instruction ROM
  InstROM instr_ROM1(
	.InstAddress   (PC), 
	.InstOut       (Instruction)
	);

  assign load_inst = Instruction[8:6]==3'b110;

// reg file
	reg_file #(.W(8),.D(4)) reg_file1 (
		.CLK    				  ,
		.write_en  (reg_wr_en)    , 
		.raddrA    ({1'b0,Instruction[5:3]}), //concatenate with 0 to give us 4 bits
		.raddrB    ({1'b0,Instruction[2:0]}), 
		.waddr     ({1'b0,Instruction[5:3]+1}), 	  // mux above
		.data_in   (regWriteValue) , 
		.data_outA (ReadA        ) , 
		.data_outB (ReadB		 )
	);

//	.raddrA ({Instruction[5:3],1'b0});
//	.raddrB ({Instruction[5:3],1'b1});





    assign InA = ReadA;						// connect RF out to ALU in
	assign InB = ReadB;
	assign MEM_WRITE = (Instruction == 9'h111);  // mem_store command
	assign regWriteValue = load_inst? Mem_Out : ALU_out;  // 2:1 switch into reg_file
    ALU ALU1  (
	  .INPUTA  (InA),
	  .INPUTB  (InB), 
	  .OP      (Instruction[8:6]),
	  .OUT     (ALU_out),//regWriteValue),
	  .SC_IN   ,//(SC_IN),
	  .SC_OUT  ,
	  .ZERO ,
	  .BEVEN
	  );
  
	data_mem data_mem1(
		.DataAddress  (ReadA)    , 
		.ReadMem      (1'b1),          //(MEM_READ) ,   always enabled 
		.WriteMem     (MEM_WRITE), 
		.DataIn       (memWriteValue), 
		.DataOut      (Mem_Out)  , 
		.CLK 		  		     ,
		.reset		  (start)
	);

*/
	
// count number of instructions executed
/*always_ff @(posedge clk)
  if (start == 1)	   // if(start)
  	cycle_ct <= 0;
  else if(halt == 0)   // if(!halt)
  	cycle_ct <= cycle_ct+16'b1; */


always_ff @(posedge clk)    // carry/shift register
  if(start)
    carry_in <= 0;          // clear/reset the carry
  else
    carry_in <= carry_out;     // update the carry
  

endmodule
