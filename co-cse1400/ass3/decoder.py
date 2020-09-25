message = [ 
        '0011010000000010000000000000000000000000000000010000000100110000',
        '0011010000000010000000000000000000000000000000010000000100110000',
        '0000000000000010000000000000000000000000000100000000000100100001',
        '0000001000000000000000000000000000000000000010010000000101010111',
        '0011010000000010000000000000000000000000000000010000000100110000',
        '0011010000000010000000000000000000000000000000010000000100110000',
        '0011010000000010000000000000000000000000000000010000000100110000',
        '0011010000000010000000000000000000000000000000010000000100110000',
        ]  


def decode(address):
    block = message[address]
    print "Decoding message: \n%s" % block
    
    block = block[16:]      # choping first 2 bytes

    # andress is stored in 3-6
    # removed the first 16 bits so now we have 48

    next_andress = block[:32]
    block = block[32:]

    char = block[:8]
    block = block[8:]

    times = block
    # print char
    
    print "next andress: %s  length: %d" % (next_andress, len(next_andress))
    print "time: %s  length: %d" % (times, len(times))
    print "char: %s  length: %d" % (char, len(char))

# decode(0)
# decode(1)
# decode(2d)
def pad(stri):
    print(len(stri))
    for _ in range(0, 64- len(stri)):
        stri = "0" + stri

    print(len(stri))
    print(stri)


pad("0011010000000010000000000000000000000000000000010000000100110000")
