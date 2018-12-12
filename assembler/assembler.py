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

def makeBin (num, length):
    bin = format(num, 'b')
    while (len(bin) < length):
        bin = '0' + bin
    return bin

def printIType(op, rs, rt, imm, outfile, line):
    op = makeBin(op, 4)
    rs = makeBin(rs, 4)
    rt = makeBin(rt, 4)
    imm = makeBin(imm, 8)

    with open(outfile, "a") as text_file:
        str = op + rs + rt + imm + "\n"
        print 'I: ' + str
        text_file.write(str)

def printRType(op, rs, rt, rd, shamt, funct, outfile, line):
    op = makeBin(op, 4)
    rs = makeBin(rs, 4)
    rt = makeBin(rt, 4)
    rd = makeBin(rd, 4)
    shamt = makeBin(shamt, 4)
    funct = makeBin(funct, 4)

    with open(outfile, "a") as text_file:
        str = op + rs + rt + rd + shamt + funct + "\n"
        print 'R: ' + str
        text_file.write(str)

filename = sys.argv[1]
outfile = sys.argv[2]

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

        printIType(op, rs, rt, imm, outfile, line)

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
    
        printRType(op, rs, rt, rd, shamt, funct, outfile, line)

    else:
        print "ERROR: Not in R or I " + line
