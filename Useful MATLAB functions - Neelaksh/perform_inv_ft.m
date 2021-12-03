function [y_t, t_axis]=perform_inv_ft(Y_f, Fs)
    y_t = ifft(Y_f);
    y_t = fftshift(y_t);
    t_span = floor(length(y_t)/(2*Fs));
    t_axis = -t_span: 1/Fs: t_span;
end