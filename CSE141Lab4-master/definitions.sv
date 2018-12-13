//This file defines the parameters used in the alu
package definitions;
    
// Instruction map
    const logic [2:0]kADD  = 3'b000;
    const logic [2:0]kLSH  = 3'b001;
    const logic [2:0]kRSH  = 3'b010;
    const logic [2:0]kXOR  = 3'b011;
    const logic [2:0]kAND  = 3'b100;
    const logic [2:0]kSUB  = 3'b101;
    const logic [2:0]kCLR  = 3'b110;
	
    const logic [4:0]oXOR = 5'b00000;
    const logic [4:0]oXORALL = 5'b00001;
    const logic [4:0]oAND = 5'b00010;
    const logic [4:0]oOR  = 5'b00011;
    const logic [4:0]oSLL = 5'b00100;
    const logic [4:0]oSRL = 5'b00101;
    const logic [4:0]oSHLD = 5'b00110;
    const logic [4:0]oSHRD = 5'b00111;
    const logic [4:0]oADD = 5'b01000;
	const logic [4:0]oADDACROSS = 5'b01001;
	const logic [4:0]oGETPARITY = 5'b01010;
    const logic [4:0]oMEM = 5'b01011;
    const logic [4:0]oXORI = 5'b01100;
    const logic [4:0]oANDI = 5'b01101;
    const logic [4:0]oADDI = 5'b01110;
    const logic [4:0]oBNE = 5'b01111;
    const logic [4:0]oBEQ = 5'b10000;
    const logic [4:0]oBGE = 5'b10001;
    const logic [4:0]oBLT = 5'b10010;
    const logic [4:0]oBLE = 5'b10011;
    
// enum names will appear in timing diagram
    typedef enum logic[4:0] {
        XOR, XORALL, AND, OR, SLL, SRL, SHLD, SHRD,
        ADD, ADDACROSS, GETPARITY, MEM, XORI, ANDI, ADDI, BNE, BEQ,
        BGE, BLT, BLE } op_mne;
    
endpackage // definitions
