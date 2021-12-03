function [y,t]=rect_pulse_generator(Fs, T, A, offset, time_extension)
    % This function generates a rect pulse of width T
    % symmetric about origin. Fs is the sampling freq.
    % amp is the amplitude. A is the amplitude. offset
    % is used for placing the axis of symmetry at other 
    % points. i.e. A*rect((t - offset)/(2*T)).
    % time_extension (sec): is used for extending the time_axis,
    % on both sides for better plotting. It should be a +ve
    % number. 
    % the pulse and the time axis are returned.
    t = (-T/2 - time_extension): 1/Fs: (T/2 + time_extension);
    t = t + offset;
    y = A*rectangularPulse(-T/2 + offset, T/2 + offset, t);
end