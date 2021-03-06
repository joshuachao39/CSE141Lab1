import definitions::*;
// control decoder
// inputs from instrROM, ALU flags
// outputs to program_counter (fetch unit)
module Ctrl (
  input[8:0]            Instruction,	   // 9 bit machine code
  output logic          mem_read,
                        mem_write,
                        rf_write,
  output logic[4:0]     aluOp,
  output logic[3:0]     rs_addr,
                        rt_addr,
                        rd_addr,
  output logic[7:0]     imm
  );

always_comb
begin
case(Instruction)
	// lb $r0,61($r0)
	9'b000000000: begin
	  mem_read = 1'b1;
	  mem_write = 1'b0;
	  rf_write = 1'b1;
	  aluOp = 5'b01011;
	  rs_addr = 4'b0000;
	  rt_addr = 4'b0000;
	  rd_addr = 4'b0000;
	  imm = 8'b00111101;
	 end

	// lb $r1,62($r0)
	9'b000000001: begin
	  mem_read = 1'b1;
	  mem_write = 1'b0;
	  rf_write = 1'b1;
	  aluOp = 5'b01011;
	  rs_addr = 4'b0000;
	  rt_addr = 4'b0001;
	  rd_addr = 4'b0000;
	  imm = 8'b00111110;
	 end

	// lb $r2,63($r0)
	9'b000000010: begin
	  mem_read = 1'b1;
	  mem_write = 1'b0;
	  rf_write = 1'b1;
	  aluOp = 5'b01011;
	  rs_addr = 4'b0000;
	  rt_addr = 4'b0010;
	  rd_addr = 4'b0000;
	  imm = 8'b00111111;
	 end

	// li $r3,0
	9'b000000011: begin
	  mem_read = 1'b0;
	  mem_write = 1'b0;
	  rf_write = 1'b1;
	  aluOp = 5'b01011;
	  rs_addr = 4'b0000;
	  rt_addr = 4'b0011;
	  rd_addr = 4'b0000;
	  imm = 8'b00000000;
	 end

	// xori $r4,$r2,32
	9'b000000100: begin
	  mem_read = 1'b0;
	  mem_write = 1'b0;
	  rf_write = 1'b1;
	  aluOp = 5'b01100;
	  rs_addr = 4'b0100;
	  rt_addr = 4'b0010;
	  rd_addr = 4'b0000;
	  imm = 8'b00100000;
	 end

	// and $r5,$r2,$r1
	9'b000000101:
	 begin
	  mem_read = 1'b0;
	  mem_write = 1'b0;
	  rf_write = 1'b1;
	  aluOp = 5'b00010;
	  rs_addr = 4'b0010;
	  rt_addr = 4'b0001;
	  rd_addr = 4'b0101;
	  imm = 8'b00000000;
	 end

	// xorAll $r5,$r5
	9'b000000110:
	 begin
	  mem_read = 1'b0;
	  mem_write = 1'b0;
	  rf_write = 1'b1;
	  aluOp = 5'b00001;
	  rs_addr = 4'b0101;
	  rt_addr = 4'b0000;
	  rd_addr = 4'b0101;
	  imm = 8'b00000000;
	 end

	// sll $r2,$r2,1
	9'b000000111:
	 begin
	  mem_read = 1'b0;
	  mem_write = 1'b0;
	  rf_write = 1'b1;
	  aluOp = 5'b00100;
	  rs_addr = 4'b0010;
	  rt_addr = 4'b0000;
	  rd_addr = 4'b0010;
	  imm = 8'b00000001;
	 end

	// or $r2,$r2,$r5
	9'b000001000:
	 begin
	  mem_read = 1'b0;
	  mem_write = 1'b0;
	  rf_write = 1'b1;
	  aluOp = 5'b00011;
	  rs_addr = 4'b0010;
	  rt_addr = 4'b0101;
	  rd_addr = 4'b0010;
	  imm = 8'b00000000;
	 end

	// sw $r4,64($r3)
	9'b000001001: begin
	  mem_read = 1'b0;
	  mem_write = 1'b1;
	  rf_write = 1'b0;
	  aluOp = 5'b01011;
	  rs_addr = 4'b0011;
	  rt_addr = 4'b0100;
	  rd_addr = 4'b0000;
	  imm = 8'b01000000;
	 end

	// addi $r3,$r3,1
	9'b000001010: begin
	  mem_read = 1'b0;
	  mem_write = 1'b0;
	  rf_write = 1'b1;
	  aluOp = 5'b01110;
	  rs_addr = 4'b0011;
	  rt_addr = 4'b0011;
	  rd_addr = 4'b0000;
	  imm = 8'b00000001;
	 end

	// bne $r3,$r0,4
	9'b000001011: begin
	  mem_read = 1'b0;
	  mem_write = 1'b0;
	  rf_write = 1'b0;
	  aluOp = 5'b01111;
	  rs_addr = 4'b0011;
	  rt_addr = 4'b0000;
	  rd_addr = 4'b0000;
	  imm = 8'b00000100;
	 end

	// li $r3,0
	9'b000001100: begin
	  mem_read = 1'b0;
	  mem_write = 1'b0;
	  rf_write = 1'b1;
	  aluOp = 5'b01011;
	  rs_addr = 4'b0000;
	  rt_addr = 4'b0011;
	  rd_addr = 4'b0000;
	  imm = 8'b00000000;
	 end

	// li $r4,59
	9'b000001101: begin
	  mem_read = 1'b0;
	  mem_write = 1'b0;
	  rf_write = 1'b1;
	  aluOp = 5'b01011;
	  rs_addr = 4'b0000;
	  rt_addr = 4'b0100;
	  rd_addr = 4'b0000;
	  imm = 8'b00111011;
	 end

	// lb $r5,0($r3)
	9'b000001110: begin
	  mem_read = 1'b1;
	  mem_write = 1'b0;
	  rf_write = 1'b1;
	  aluOp = 5'b01011;
	  rs_addr = 4'b0011;
	  rt_addr = 4'b0101;
	  rd_addr = 4'b0000;
	  imm = 8'b00000000;
	 end

	// xor $r5,$r5,$r2
	9'b000001111:
	 begin
	  mem_read = 1'b0;
	  mem_write = 1'b0;
	  rf_write = 1'b1;
	  aluOp = 5'b00000;
	  rs_addr = 4'b0101;
	  rt_addr = 4'b0010;
	  rd_addr = 4'b0101;
	  imm = 8'b00000000;
	 end

	// and $r6,$r2,$r1
	9'b000010000:
	 begin
	  mem_read = 1'b0;
	  mem_write = 1'b0;
	  rf_write = 1'b1;
	  aluOp = 5'b00010;
	  rs_addr = 4'b0010;
	  rt_addr = 4'b0001;
	  rd_addr = 4'b0110;
	  imm = 8'b00000000;
	 end

	// xorAll $r6,$r1
	9'b000010001:
	 begin
	  mem_read = 1'b0;
	  mem_write = 1'b0;
	  rf_write = 1'b1;
	  aluOp = 5'b00001;
	  rs_addr = 4'b0001;
	  rt_addr = 4'b0000;
	  rd_addr = 4'b0110;
	  imm = 8'b00000000;
	 end

	// sll $r2,$r2,1
	9'b000010010:
	 begin
	  mem_read = 1'b0;
	  mem_write = 1'b0;
	  rf_write = 1'b1;
	  aluOp = 5'b00100;
	  rs_addr = 4'b0010;
	  rt_addr = 4'b0000;
	  rd_addr = 4'b0010;
	  imm = 8'b00000001;
	 end

	// or $r2,$r2,$r6
	9'b000010011:
	 begin
	  mem_read = 1'b0;
	  mem_write = 1'b0;
	  rf_write = 1'b1;
	  aluOp = 5'b00011;
	  rs_addr = 4'b0010;
	  rt_addr = 4'b0110;
	  rd_addr = 4'b0010;
	  imm = 8'b00000000;
	 end

	// add $r7,$r0,$r3
	9'b000010100:
	 begin
	  mem_read = 1'b0;
	  mem_write = 1'b0;
	  rf_write = 1'b1;
	  aluOp = 5'b01000;
	  rs_addr = 4'b0000;
	  rt_addr = 4'b0011;
	  rd_addr = 4'b0111;
	  imm = 8'b00000000;
	 end

	// sw $r5,0($r7)
	9'b000010101: begin
	  mem_read = 1'b0;
	  mem_write = 1'b1;
	  rf_write = 1'b0;
	  aluOp = 5'b01011;
	  rs_addr = 4'b0111;
	  rt_addr = 4'b0101;
	  rd_addr = 4'b0000;
	  imm = 8'b00000000;
	 end

	// addi $r3,$r3,1
	9'b000010110: begin
	  mem_read = 1'b0;
	  mem_write = 1'b0;
	  rf_write = 1'b1;
	  aluOp = 5'b01110;
	  rs_addr = 4'b0011;
	  rt_addr = 4'b0011;
	  rd_addr = 4'b0000;
	  imm = 8'b00000001;
	 end

	// bne $r3,$r4,14
	9'b000010111: begin
	  mem_read = 1'b0;
	  mem_write = 1'b0;
	  rf_write = 1'b0;
	  aluOp = 5'b01111;
	  rs_addr = 4'b0011;
	  rt_addr = 4'b0100;
	  rd_addr = 4'b0000;
	  imm = 8'b00001110;
	 end

	// END/HALT
	9'b000011000: begin
	  mem_read = 1'b0;
	  mem_write = 1'b0;
	  rf_write = 1'b0;
	  aluOp = 5'b11111;
	  rs_addr = 4'b0000;
	  rt_addr = 4'b0000;
	  rd_addr = 4'b0000;
	  imm = 8'b00000000;
	 end

/*----------------------------------------------------------------
FIXED TO FLOAT
----------------------------------------------------------------*/
	// lw $r0,128($r0)
	9'b001001110: begin
	  mem_read = 1'b1;
	  mem_write = 1'b0;
	  rf_write = 1'b1;
	  aluOp = 5'b01011;
	  rs_addr = 4'b0000;
	  rt_addr = 4'b0000;
	  rd_addr = 4'b0000;
	  imm = 8'b10000000;
	 end

	// lw $r1,129($r0)
	9'b001001111: begin
	  mem_read = 1'b1;
	  mem_write = 1'b0;
	  rf_write = 1'b1;
	  aluOp = 5'b01011;
	  rs_addr = 4'b0000;
	  rt_addr = 4'b0001;
	  rd_addr = 4'b0000;
	  imm = 8'b10000001;
	 end

	// andi $r2,$r0,128
	9'b001010000: begin
	  mem_read = 1'b0;
	  mem_write = 1'b0;
	  rf_write = 1'b1;
	  aluOp = 5'b01101;
	  rs_addr = 4'b0010;
	  rt_addr = 4'b0000;
	  rd_addr = 4'b0000;
	  imm = 8'b10000000;
	 end

	// li $r3,29
	9'b001010001: begin
	  mem_read = 1'b0;
	  mem_write = 1'b0;
	  rf_write = 1'b1;
	  aluOp = 5'b01011;
	  rs_addr = 4'b0000;
	  rt_addr = 4'b0011;
	  rd_addr = 4'b0000;
	  imm = 8'b00011101;
	 end

	// shld $r0,$r1,1
	9'b001010010:
	 begin
	  mem_read = 1'b0;
	  mem_write = 1'b0;
	  rf_write = 1'b1;
	  aluOp = 5'b00110;
	  rs_addr = 4'b0001;
	  rt_addr = 4'b0000;
	  rd_addr = 4'b0000;
	  imm = 8'b00000001;
	 end

	// sll $r1,$r1,1
	9'b001010011:
	 begin
	  mem_read = 1'b0;
	  mem_write = 1'b0;
	  rf_write = 1'b1;
	  aluOp = 5'b00100;
	  rs_addr = 4'b0001;
	  rt_addr = 4'b0000;
	  rd_addr = 4'b0001;
	  imm = 8'b00000001;
	 end

	// or $r5,$r0,$r1
	9'b001010100:
	 begin
	  mem_read = 1'b0;
	  mem_write = 1'b0;
	  rf_write = 1'b1;
	  aluOp = 5'b00011;
	  rs_addr = 4'b0000;
	  rt_addr = 4'b0001;
	  rd_addr = 4'b0101;
	  imm = 8'b00000000;
	 end

	// bne $r5,$r0,89
	9'b001010101: begin
	  mem_read = 1'b0;
	  mem_write = 1'b0;
	  rf_write = 1'b0;
	  aluOp = 5'b01111;
	  rs_addr = 4'b0101;
	  rt_addr = 4'b0000;
	  rd_addr = 4'b0000;
	  imm = 8'b01011001;
	 end

	// and $r0,$r2,$r1
	9'b001010110:
	 begin
	  mem_read = 1'b0;
	  mem_write = 1'b0;
	  rf_write = 1'b1;
	  aluOp = 5'b00010;
	  rs_addr = 4'b0010;
	  rt_addr = 4'b0001;
	  rd_addr = 4'b0000;
	  imm = 8'b00000000;
	 end

	// sw $r0,131($r0)
	9'b001010111: begin
	  mem_read = 1'b0;
	  mem_write = 1'b1;
	  rf_write = 1'b0;
	  aluOp = 5'b01011;
	  rs_addr = 4'b0000;
	  rt_addr = 4'b0000;
	  rd_addr = 4'b0000;
	  imm = 8'b10000011;
	 end

	// sw $r1,132($r0)
	9'b001011000: begin
	  mem_read = 1'b0;
	  mem_write = 1'b1;
	  rf_write = 1'b0;
	  aluOp = 5'b01011;
	  rs_addr = 4'b0000;
	  rt_addr = 4'b0001;
	  rd_addr = 4'b0000;
	  imm = 8'b10000100;
	 end

	// andi $r4,$r0,128
	9'b001011001: begin
	  mem_read = 1'b0;
	  mem_write = 1'b0;
	  rf_write = 1'b1;
	  aluOp = 5'b01101;
	  rs_addr = 4'b0100;
	  rt_addr = 4'b0000;
	  rd_addr = 4'b0000;
	  imm = 8'b10000000;
	 end

	// li $r7,128
	9'b001011010: begin
	  mem_read = 1'b0;
	  mem_write = 1'b0;
	  rf_write = 1'b1;
	  aluOp = 5'b01011;
	  rs_addr = 4'b0000;
	  rt_addr = 4'b0111;
	  rd_addr = 4'b0000;
	  imm = 8'b10000000;
	 end

	// beq $r4,$r7,96
	9'b001011011: begin
	  mem_read = 1'b0;
	  mem_write = 1'b0;
	  rf_write = 1'b0;
	  aluOp = 5'b10000;
	  rs_addr = 4'b0100;
	  rt_addr = 4'b0111;
	  rd_addr = 4'b0000;
	  imm = 8'b01100000;
	 end

	// addi $r3,$r3,-1
	9'b001011100: begin
	  mem_read = 1'b0;
	  mem_write = 1'b0;
	  rf_write = 1'b1;
	  aluOp = 5'b01110;
	  rs_addr = 4'b0011;
	  rt_addr = 4'b0011;
	  rd_addr = 4'b0000;
	  imm = 8'b11111111;
	 end

	// shld $r0,$r1,1
	9'b001011101:
	 begin
	  mem_read = 1'b0;
	  mem_write = 1'b0;
	  rf_write = 1'b1;
	  aluOp = 5'b00110;
	  rs_addr = 4'b0001;
	  rt_addr = 4'b0000;
	  rd_addr = 4'b0000;
	  imm = 8'b00000001;
	 end

	// sll $r1,$r1,1
	9'b001011110:
	 begin
	  mem_read = 1'b0;
	  mem_write = 1'b0;
	  rf_write = 1'b1;
	  aluOp = 5'b00100;
	  rs_addr = 4'b0001;
	  rt_addr = 4'b0000;
	  rd_addr = 4'b0001;
	  imm = 8'b00000001;
	 end

	// beq $r0,$r0,89
	9'b001011111: begin
	  mem_read = 1'b0;
	  mem_write = 1'b0;
	  rf_write = 1'b0;
	  aluOp = 5'b10000;
	  rs_addr = 4'b0000;
	  rt_addr = 4'b0000;
	  rd_addr = 4'b0000;
	  imm = 8'b01011001;
	 end

	// andi $r4,$r1,16
	9'b001100000: begin
	  mem_read = 1'b0;
	  mem_write = 1'b0;
	  rf_write = 1'b1;
	  aluOp = 5'b01101;
	  rs_addr = 4'b0100;
	  rt_addr = 4'b0001;
	  rd_addr = 4'b0000;
	  imm = 8'b00010000;
	 end

	// andi $r5,$r1,8
	9'b001100001: begin
	  mem_read = 1'b0;
	  mem_write = 1'b0;
	  rf_write = 1'b1;
	  aluOp = 5'b01101;
	  rs_addr = 4'b0101;
	  rt_addr = 4'b0001;
	  rd_addr = 4'b0000;
	  imm = 8'b00001000;
	 end

	// li $r7,8
	9'b001100010: begin
	  mem_read = 1'b0;
	  mem_write = 1'b0;
	  rf_write = 1'b1;
	  aluOp = 5'b01011;
	  rs_addr = 4'b0000;
	  rt_addr = 4'b0111;
	  rd_addr = 4'b0000;
	  imm = 8'b00001000;
	 end

	// bne $r4,$r7,104
	9'b001100011: begin
	  mem_read = 1'b0;
	  mem_write = 1'b0;
	  rf_write = 1'b0;
	  aluOp = 5'b01111;
	  rs_addr = 4'b0100;
	  rt_addr = 4'b0111;
	  rd_addr = 4'b0000;
	  imm = 8'b01101000;
	 end

	// li $r7,4
	9'b001100100: begin
	  mem_read = 1'b0;
	  mem_write = 1'b0;
	  rf_write = 1'b1;
	  aluOp = 5'b01011;
	  rs_addr = 4'b0000;
	  rt_addr = 4'b0111;
	  rd_addr = 4'b0000;
	  imm = 8'b00000100;
	 end

	// bne $r5,$r7,104
	9'b001100101: begin
	  mem_read = 1'b0;
	  mem_write = 1'b0;
	  rf_write = 1'b0;
	  aluOp = 5'b01111;
	  rs_addr = 4'b0101;
	  rt_addr = 4'b0111;
	  rd_addr = 4'b0000;
	  imm = 8'b01101000;
	 end

	// addacross $r0,$r1,8
	9'b001100110:
	 begin
	  mem_read = 1'b0;
	  mem_write = 1'b0;
	  rf_write = 1'b1;
	  aluOp = 5'b01001;
	  rs_addr = 4'b0001;
	  rt_addr = 4'b0000;
	  rd_addr = 4'b0000;
	  imm = 8'b00001000;
	 end

	// beq $r0,$r0,109
	9'b001100111: begin
	  mem_read = 1'b0;
	  mem_write = 1'b0;
	  rf_write = 1'b0;
	  aluOp = 5'b10000;
	  rs_addr = 4'b0000;
	  rt_addr = 4'b0000;
	  rd_addr = 4'b0000;
	  imm = 8'b01101101;
	 end

	// bne $r4,$r0,109
	9'b001101000: begin
	  mem_read = 1'b0;
	  mem_write = 1'b0;
	  rf_write = 1'b0;
	  aluOp = 5'b01111;
	  rs_addr = 4'b0100;
	  rt_addr = 4'b0000;
	  rd_addr = 4'b0000;
	  imm = 8'b01101101;
	 end

	// bne $r5,$r7,109
	9'b001101001: begin
	  mem_read = 1'b0;
	  mem_write = 1'b0;
	  rf_write = 1'b0;
	  aluOp = 5'b01111;
	  rs_addr = 4'b0101;
	  rt_addr = 4'b0111;
	  rd_addr = 4'b0000;
	  imm = 8'b01101101;
	 end

	// andi $r6,$r1,15
	9'b001101010: begin
	  mem_read = 1'b0;
	  mem_write = 1'b0;
	  rf_write = 1'b1;
	  aluOp = 5'b01101;
	  rs_addr = 4'b0110;
	  rt_addr = 4'b0001;
	  rd_addr = 4'b0000;
	  imm = 8'b00001111;
	 end

	// beq $r6,$r0,109
	9'b001101011: begin
	  mem_read = 1'b0;
	  mem_write = 1'b0;
	  rf_write = 1'b0;
	  aluOp = 5'b10000;
	  rs_addr = 4'b0110;
	  rt_addr = 4'b0000;
	  rd_addr = 4'b0000;
	  imm = 8'b01101101;
	 end

	// addacross $r0,$r1,8
	9'b001101100:
	 begin
	  mem_read = 1'b0;
	  mem_write = 1'b0;
	  rf_write = 1'b1;
	  aluOp = 5'b01001;
	  rs_addr = 4'b0001;
	  rt_addr = 4'b0000;
	  rd_addr = 4'b0000;
	  imm = 8'b00001000;
	 end

	// bne $r0,$r0,113
	9'b001101101: begin
	  mem_read = 1'b0;
	  mem_write = 1'b0;
	  rf_write = 1'b0;
	  aluOp = 5'b01111;
	  rs_addr = 4'b0000;
	  rt_addr = 4'b0000;
	  rd_addr = 4'b0000;
	  imm = 8'b01110001;
	 end

	// bne $r1,$r0,113
	9'b001101110: begin
	  mem_read = 1'b0;
	  mem_write = 1'b0;
	  rf_write = 1'b0;
	  aluOp = 5'b01111;
	  rs_addr = 4'b0001;
	  rt_addr = 4'b0000;
	  rd_addr = 4'b0000;
	  imm = 8'b01110001;
	 end

	// addi $r3,$r3,1
	9'b001101111: begin
	  mem_read = 1'b0;
	  mem_write = 1'b0;
	  rf_write = 1'b1;
	  aluOp = 5'b01110;
	  rs_addr = 4'b0011;
	  rt_addr = 4'b0011;
	  rd_addr = 4'b0000;
	  imm = 8'b00000001;
	 end

	// li $r0,128
	9'b001110000: begin
	  mem_read = 1'b0;
	  mem_write = 1'b0;
	  rf_write = 1'b1;
	  aluOp = 5'b01011;
	  rs_addr = 4'b0000;
	  rt_addr = 4'b0000;
	  rd_addr = 4'b0000;
	  imm = 8'b10000000;
	 end

	// li $r4,0
	9'b001110001: begin
	  mem_read = 1'b0;
	  mem_write = 1'b0;
	  rf_write = 1'b1;
	  aluOp = 5'b01011;
	  rs_addr = 4'b0000;
	  rt_addr = 4'b0100;
	  rd_addr = 4'b0000;
	  imm = 8'b00000000;
	 end

	// li $r5,0
	9'b001110010: begin
	  mem_read = 1'b0;
	  mem_write = 1'b0;
	  rf_write = 1'b1;
	  aluOp = 5'b01011;
	  rs_addr = 4'b0000;
	  rt_addr = 4'b0101;
	  rd_addr = 4'b0000;
	  imm = 8'b00000000;
	 end

	// or $r4,$r4,$r2
	9'b001110011:
	 begin
	  mem_read = 1'b0;
	  mem_write = 1'b0;
	  rf_write = 1'b1;
	  aluOp = 5'b00011;
	  rs_addr = 4'b0100;
	  rt_addr = 4'b0010;
	  rd_addr = 4'b0100;
	  imm = 8'b00000000;
	 end

	// sll $r3,$r3,2
	9'b001110100:
	 begin
	  mem_read = 1'b0;
	  mem_write = 1'b0;
	  rf_write = 1'b1;
	  aluOp = 5'b00100;
	  rs_addr = 4'b0011;
	  rt_addr = 4'b0000;
	  rd_addr = 4'b0011;
	  imm = 8'b00000010;
	 end

	// or $r4,$r4,$r3
	9'b001110101:
	 begin
	  mem_read = 1'b0;
	  mem_write = 1'b0;
	  rf_write = 1'b1;
	  aluOp = 5'b00011;
	  rs_addr = 4'b0100;
	  rt_addr = 4'b0011;
	  rd_addr = 4'b0100;
	  imm = 8'b00000000;
	 end

	// shrd $r1,$r0,6
	9'b001110110:
	 begin
	  mem_read = 1'b0;
	  mem_write = 1'b0;
	  rf_write = 1'b1;
	  aluOp = 5'b00111;
	  rs_addr = 4'b0000;
	  rt_addr = 4'b0000;
	  rd_addr = 4'b0001;
	  imm = 8'b00000110;
	 end

	// srl $r0,$r0,6
	9'b001110111:
	 begin
	  mem_read = 1'b0;
	  mem_write = 1'b0;
	  rf_write = 1'b1;
	  aluOp = 5'b00101;
	  rs_addr = 4'b0000;
	  rt_addr = 4'b0000;
	  rd_addr = 4'b0000;
	  imm = 8'b00000110;
	 end

	// or $r4,$r4,$r0
	9'b001111000:
	 begin
	  mem_read = 1'b0;
	  mem_write = 1'b0;
	  rf_write = 1'b1;
	  aluOp = 5'b00011;
	  rs_addr = 4'b0100;
	  rt_addr = 4'b0000;
	  rd_addr = 4'b0100;
	  imm = 8'b00000000;
	 end

	// sw $r4,131($r0)
	9'b001111001: begin
	  mem_read = 1'b0;
	  mem_write = 1'b1;
	  rf_write = 1'b0;
	  aluOp = 5'b01011;
	  rs_addr = 4'b0000;
	  rt_addr = 4'b0100;
	  rd_addr = 4'b0000;
	  imm = 8'b10000011;
	 end

	// sw $r1,132($r0)
	9'b001111010: begin
	  mem_read = 1'b0;
	  mem_write = 1'b1;
	  rf_write = 1'b0;
	  aluOp = 5'b01011;
	  rs_addr = 4'b0000;
	  rt_addr = 4'b0001;
	  rd_addr = 4'b0000;
	  imm = 8'b10000100;
	 end
	
	// END/HALT
	9'b001111011: begin
	  mem_read = 1'b0;
	  mem_write = 1'b0;
	  rf_write = 1'b0;
	  aluOp = 5'b11111;
	  rs_addr = 4'b0000;
	  rt_addr = 4'b0000;
	  rd_addr = 4'b0000;
	  imm = 8'b00000000;
	 end

	
		
endcase
end
endmodule