function filter=LPF_filter(B, Fs, t_lim, t_axis, mode)
    % mode = 0 -> use t_axis;
    % mode = 1 -> use Fs, t_lim;
    if mode
        t = -t_lim:1/Fs:t_lim;
    else
        t = t_axis;
    end
    filter = 2*B*sinc(2*B*t);
end