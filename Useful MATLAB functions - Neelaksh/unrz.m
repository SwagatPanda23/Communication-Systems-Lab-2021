function [t,x] = unrz(bits, bitrate, res)
%   Encode bit string using ON-OFF NRZ code.

T = length(bits)/bitrate; % full time of bit sequence
n = res;
N = n*length(bits);
dt = T/N;
t = 0:dt:T;
x = zeros(1,length(t)); % output signal
for i = 0:length(bits)-1
  if bits(i+1) == 1
    x(i*n+1:(i+1)*n) = 1;
  else
    x(i*n+1:(i+1)*n) = 0;
  end
end