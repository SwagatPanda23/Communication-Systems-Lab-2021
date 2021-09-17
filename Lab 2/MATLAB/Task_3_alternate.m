%%Generate a binary Huffman code, displaying the average code length and the cell array containing the codeword dictionary.
inputSig = {'s','w', 'a','g','t',''};
prob = [0.3 0.1 0.3 0.12 0.12 0.06]; % Symbol probability vector
[dict,avglen] = huffmandict(inputSig,prob);
input={'s'}
abc=huffmanenco(input,dict)
abc=abc'
huffmandeco(abc, dict)