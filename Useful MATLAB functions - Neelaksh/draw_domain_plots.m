function draw_domain_plots(y, Fs, ttl_t, xlab_t, ylab_t, ttl_f, xlab_f, ylab_f, fig_no1, fig_no2)
    t_axis = 0:1/Fs:length(y)/Fs;
    t_axis = t_axis(1:end-1);
    figure(fig_no1);
    plot(t_axis, y);
    title(ttl_t);
    xlabel(xlab_t);
    ylabel(ylab_t);
    axis([0 t_axis(end) min(y) max(y)]);
    [Y, F_axis] = perform_fft(y, Fs);
    Y = abs(Y);
    figure(fig_no2);
    plot(F_axis, Y);
    title(ttl_f);
    xlabel(xlab_f);
    ylabel(ylab_f);
    axis([-Fs/2 Fs/2 min(Y) max(Y)])
end