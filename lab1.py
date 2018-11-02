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

def fixedToFloat(I):
    sign_bit = I[15]
    exponent = 29
    mantissa = I
    while mantissa[15] == 0:
        mantissa = mantissa << 1
        exponent -= 1
    # rounding
    if mantissa[4] == 1 and mantissa[3] == 1: # clearly above half
        mantissa += 8

    # potentially on the cusp
    if mantissa[4] == 1 and mantissa[3] == 0:
        isNotCusp = mantissa[0] or mantissa[1] or mantissa[2]
        # not on the cusp, so just round up
        if isNotCusp == 1:
            mantissa += 8
        else:
            # round to nearest even; if mantissa is already odd, nearest even is one up
            if mantissa[5] == 1:
                mantissa += 8

    # overflow. Alternatively, check if everything is a 0.
    if mantissa[15] == 1:
        mantissa = mantissa >> 1
        exponent += 1

    return sign_bit.concat(exponent).concat(mantissa)

def floatToFixed(F):
    sign_bit = F[15]
    biasedExponent = F[14:10]
    mantissa = F[9:0]
    mantissa[10] = 1
    exponent = biasedExponent - 15
    # always rounded to 0
    if exponent < -1:
        return sign_bit + "000000000000000"
    if exponent == -1:
        # always rounded to 1
        if mantissa[9] == 1:
            return sign_bit + "000000000000001"
        else:
            # everything is 0, round to 0
            if or(mantissa[8] .. mantissa[0]) == 0:
                return sign_bit + "000000000000000"
            # gotta round up
            else:
                return sign_bit + "000000000000001"
    # just hardcode overflow
    if exponent == 15 or exponent == 16:
        return sign_bit + "111111111111111"
    # weird rounding corner case, no sticky bits
    if exponent == 9:
        # always round down
        if mantissa[0] == 0:
            mantissa.shift_right(1)
        # nearest even
        else:
            # it's odd, round up
            if mantissa[1] == 1:
                mantissa.shift_right(1)
                mantissa += 1
            else:
                mantissa.shift_right(1)
        mantissa[15] = sign_bit
        return mantissa
    # dont need to worry about truncation, just add zeroes
    if exponent > 9:
        mantissa.shift_left(exponent-10)
        mantissa[15] = sign_bit
        return mantissa
    # exponent is 0-8 inclusive
    else:
        sticky = 0
        round = mantissa[9-exponent]
        for _ in range(10-exponent):
            sticky |= mantissa[0]
            mantissa.shift_right(1)
        if round == 1:
            # if sticky, then we always round up. if not sticky, we round up if mantissa is odd
            if sticky == 1 or mantissa[0] == 1:
                mantissa += 1

        mantissa[15] = sign_bit
        return mantissa
