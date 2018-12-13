import sys

def getRegNum(stri):
    regNum = int(stri.split('r')[1])
    print stri + " " + str(regNum)
    return regNum

def parseAddr(str):
    stuff = str.split('(')
    imm = int(stuff[0])
    regNum = getRegNum(stuff[1][0:3])
    return (regNum, imm)


aluOp = {
    "xor":"5'b00000",
    "xorAll":"5'b00001",
    "and": "5'b00010",
    "or":"5'b00011",
    "sll":"5'b00100",
    "srl":"5'b00101",
    "shld":"5'b00110",
    "shrd":"5'b00111",
    "add":"5'b01000",
    "addacross":"5'b01001",
    "getParity":"5'b01010",
    "mem":"5'b01011",
    "xori":"5'b01100",
    "andi":"5'b01101",
    "addi":"5'b01110",
    "bne":"5'b01111",
    "beq":"5'b10000",
    "bge":"5'b10001",
    "blt":"5'b10010",
    "ble":"5'b10011",
    "lb":"5'b01011",
    "lw":"5'b01011",
    "li":"5'b01011",
    "sw":"5'b01011",
    "sb":"5'b01011",
}

memRead = {"lb", "lw"}
memWrite = {"sw", "sb"}
rfDontWrite = {"sw", "sb", "bne", "beq", "bge", "blt", "ble"}

def makeBin (num, length):
    bin = format(num, 'b')
    while (len(bin) < length):
        bin = '0' + bin
    return bin

def printIType(op, rs, rt, imm, outfile, line, instr, index):
    op = makeBin(op, 4)
    rs = makeBin(rs, 4)
    rt = makeBin(rt, 4)
    imm = makeBin(imm, 8)
    index = makeBin(index,9)

    with open(outfile, "a") as text_file:
        str = op + rs + rt + imm + "\n"
        print 'I: ' + str
        text_file.write(str)

    rs = "4'b" + rs
    rt = "4'b" + rt
    rd = "4'b0000"
    imm = "8'b" + imm
    index = "9'b" + index

    if instr in memRead:
        mem_read = "1'b1"
    else:
        mem_read = "1'b0"

    if instr in memWrite:
        mem_write = "1'b1"
    else:
        mem_write = "1'b0"

    if instr in rfDontWrite:
        rf_write = "1'b0"
    else:
        rf_write = "1'b1"

    alu_op = aluOp[instr]
    out = "// " + line + "\n" + index + ": begin\n"+"  mem_read = "+mem_read+";\n  mem_write = "+mem_write+";\n  rf_write = "+rf_write+";\n  aluOp = "+alu_op+";\n  rs_addr = "+rs+ ";\n  rt_addr = "+rt + ";\n  rd_addr = " + rd + ";\n  imm = "+imm + ";\n end\n\n"

    with open("verilog.txt", "a") as text_file:
        text_file.write(out)

def printRType(op, rs, rt, rd, shamt, funct, outfile, line, instr, index):
    op = makeBin(op, 4)
    rs = makeBin(rs, 4)
    rt = makeBin(rt, 4)
    rd = makeBin(rd, 4)
    pshamt = makeBin(shamt, 8)
    shamt = makeBin(shamt, 4)
    funct = makeBin(funct, 4)
    index = makeBin(index,9)

    with open(outfile, "a") as text_file:
        str = op + rs + rt + rd + shamt + funct + "\n"
        print 'R: ' + str
        text_file.write(str)

    rs = "4'b" + rs
    rt = "4'b" + rt
    rd = "4'b" + rd
    imm = "8'b" + pshamt
    index = "9'b" + index

    if instr in memRead:
        mem_read = "1'b1"
    else:
        mem_read = "1'b0"

    if instr in memWrite:
        mem_write = "1'b1"
    else:
        mem_write = "1'b0"

    if instr in rfDontWrite:
        rf_write = "1'b0"
    else:
        rf_write = "1'b1"

    alu_op = aluOp[instr]

    out = "// " + line + "\n" + index + ":\n begin\n"+"  mem_read = "+mem_read+";\n  mem_write = "+mem_write+";\n  rf_write = "+rf_write+";\n  aluOp = "+alu_op+";\n  rs_addr = "+rs+ ";\n  rt_addr = "+rt + ";\n  rd_addr = " + rd + ";\n  imm = "+imm + ";\n end\n\n"

    with open("verilog.txt", "a") as text_file:
        text_file.write(out)

filename = sys.argv[1]
outfile = sys.argv[2]
startindex = int(sys.argv[3])

i_type = {
        'lb': 1, 
        'lw': 2, 
        'li': 3, 
        'sw': 4, 
        'sb': 5, 
        'xori': 6, 
        'andi': 7, 
        'addi': 8, 
        'bne' : 9, 
        'beq' : 10, 
        'bge' : 11,
        'blt' : 12,
        'ble' : 13
    }

r_type = {
        'xor' : 0,
        'xorAll' : 1,
        'and' : 2,
        'or'  : 3,
        'sll' : 4,
        'srl' : 5,
        'shld': 6,
        'shrd': 7,
        'add' : 8,
        'addacross' : 9,
        'getParity' : 10,
    }

load_store = {'lb', 'lw', 'li', 'sw', 'sb'}
shifts = {'sll', 'srl', 'shld', 'shrd', 'addacross'}
arith = {'xor', 'and', 'or', 'add', 'getParity'}

lines = open(filename).read().splitlines()

for line in lines:

    # label
    if ':' in line:
        continue

    data = line.split(' ')
    instr = data[0]
    operands = data[1].split(',')

    if instr in i_type:
        op = i_type[instr]
        rs = 0
        rt = 0
        imm = 0
        if instr in load_store: 
            if instr == 'li':
                rt = getRegNum(operands[0])
                imm = int(operands[1])
            else:
                rt = getRegNum(operands[0])
                (rs, imm) = parseAddr(operands[1])
        else:
            rs = getRegNum(operands[0])
            rt = getRegNum(operands[1])
            imm = int(operands[2])

        printIType(op, rs, rt, imm, outfile, line, instr, startindex)

    elif instr in r_type:
        op = 0
        rd = 0
        rs = 0
        rt = 0
        shamt = 0
        funct = r_type[instr]

        if instr in shifts:
            rd = getRegNum(operands[0])
            rs = getRegNum(operands[1])
            shamt = int(operands[2])
        elif instr in arith:
            rd = getRegNum(operands[0])
            rs = getRegNum(operands[1])
            rt = getRegNum(operands[2])
        elif instr == 'xorAll':
            rd = getRegNum(operands[0])
            rs = getRegNum(operands[1])
        else: 
            print 'ERROR: R type instruction not found: ' + line
    
        printRType(op, rs, rt, rd, shamt, funct, outfile, line, instr, startindex)

    else:
        print "ERROR: Not in R or I " + line

    startindex += 1
