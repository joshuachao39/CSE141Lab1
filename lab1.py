def encrypt():
  """
  Note that we are assuming data memory slots 0-54 already have at least
  9 prepended spaces and have appended spaces as necessary
  """
  IV = getMemFrom(program1, 63) # relative memory addressing, IV == initial vector == initial LSFR state
  tap_sequence = getMemFrom(program1, 62)
  # we are guaranteed 55 characters, just encrypt them all
  for i in xrange(55):
      putMemFrom(program2, i, xor(getMemFrom(program1, i), IV)) # relative addressing, program2 starts from mem slot 64
      parity = getParity(IV, tap_sequence)
      IV = IV << 1
      IV[0] = parity

def decrypt():
    # find out the initial LSFR state
    IV = xor(" ", getMemFrom(program2, 0)) # relative addressing
    # set up all temp_ivs to start with original IV. Note that we can use address spaces 55-63 however we want, because we know they will always be spaces
    for i in xrange(8):
        putMemFrom(temp_ivs, i, IV)
    # find the correct tap sequence
    candidateTaps = b11111111;
    for i in xrange(1, 9):
        mutated_IV = xor(" ", getMemFrom(program2, i))
        for ts_idx in xrange(8):
            if getBit(candidateTaps, ts_idx) == 1:
                prevIV = getMemFrom(temp_ivs, ts_idx)
                parity = getParity(prevIV, tap_table.lookup(ts_idx)) # all 8 possible tap sequences are hardcoded in a lookup table
                prevIV = prevIV << 1
                prevIV[0] = parity
                if prevIV == mutated_IV:
                    putMemFrom(temp_ivs, ts_idx, prevIV)
                else:
                    set0Bit(candidateTaps, ts_idx)

    tap_sequence = tap_table.lookup(getIndex(candidateTaps))
    hasSeenNonSpaceChar = False
    IV = getMemFrom(temp_ivs, getIndex(candidateTaps))
    i = 9
    while (True):
        decodedChar = xor(IV, getMemFrom(program2, i))
        parity = getParity(IV, tap_sequence)
        IV = IV << 1
        IV[0] = parity
        if decodedChar != " ":
            break;
        else:
            i = i + 1

    numSpaces = i
    while i < 129:
        putMemFrom(program1, i - numSpaces, xor(getMemFrom(program2, i)))
        parity = getParity(IV, tap_sequence)
        IV = IV << 1
        IV[0] = parity

def 
