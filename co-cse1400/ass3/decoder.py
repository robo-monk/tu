message = [ 

0X00020000000A0148
0X0002000000100121
0X0200000000090157
0X000200000004016F
0X0002000000020120
0X00020000000E0170
0X000200000003026C
0X00020000000D0165
0X02000000000C016C
0X020000000011016F
0X0002000000060165
0X0002000000070168
0X02000000000F0164
0X000200000005016C
0X000200000001013F
0X00020000000B0120
0X000200000012010A
0X0200000000080172
0X000200000000010A
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
