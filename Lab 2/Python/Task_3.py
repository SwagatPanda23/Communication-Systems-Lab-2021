
my_str = "Swagat Panda"
code = []
binary_rep =[]
decode = []

# Coding the string in binary
for i in my_str:
    code.append(ord(i))
    binary_rep.append(bin(ord(i)).replace("0b", ""))

binary_str = [''.join(i) for i in [binary_rep]]

# Decoding the string
for j in code:
    decode.append(chr(j))

dec_str = [''.join(i) for i in [decode]]

print(code)
print(binary_rep)
print(binary_str[0])
print(dec_str[0])

