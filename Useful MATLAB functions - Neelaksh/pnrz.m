function [t,x] = pnrz(bits, bitrate, res)
% PNRZ:Encode bit string using Polar NRZ code.
% @param [in]    bits: The sequence to encode.
% @param [in] bitrate: The bitrate.
% @param [in]     res: Number of samples to use per bit for generating the
% continuous time pulse. Therefore, Fs = res*bitrate.

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
    x(i*n+1:(i+1)*n) = -1;
  end
end