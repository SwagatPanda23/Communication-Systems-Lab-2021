function [Y,F_axis]=perform_fft(y, Fs)
    Y = fft(y);
    Y = fftshift(Y);
    N = length(y);
    Y = Y/max(Y);
    F_axis = linspace(-Fs/2, Fs/2, N);
end