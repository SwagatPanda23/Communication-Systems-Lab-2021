function [y,t]=rect_pulse_generator2(Fs, T, A, offset, t1, t2)
    % This function unlike the 1st takes t1 and t2 as time
    % limits and t=offset is the axis of symmetry for the
    % rect pulse. Fs is the sampling freq.
    % amp is the amplitude. A is the amplitude. offset
    % is used for placing the axis of symmetry at other 
    % points. i.e. A*rect((t - offset)/(2*T)).
    % the pulse and the time axis are returned.
    t = t1: 1/Fs: t2;
    y = A*rectangularPulse(-T/2 + offset, T/2 + offset, t);
end