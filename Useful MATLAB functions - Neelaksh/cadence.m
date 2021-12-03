% Function to introduce ON and OFF cadence in audio data samples.
% To make a signal at a cadence of t_on sec ON and t_off sec OFF
% what we can do is, we can generate a t_on sec signal then append
% t_off sec zero signal at its end. The resulting signal can 
% then be looped till be get the tone of the required duration.
function Y=cadence(t_on, t_off, t, Fs, Frq, a)
    T = 0:1/Fs:t_on; % Generating the time samples for t_on sec
    % it is important that time samples are in sync with the
    % sound sampling freq.
    y = a*sin(2*pi*Frq*T);
    % Now generating zero samples for t_off sec.
    y_z = zeros(1, Fs*t_off);
    % Now generating the looping signal. For this purpose
    % we will use the repmat function to repeat the matrix.
    Y = [y y_z];
    % We need to calculate the number of times to repeat
    % to give a tone of t sec.
    num_loops = floor(Fs*t/length(Y));
    if num_loops < 1
        num_loops = 1;
    end
    Y = repmat(Y, 1, num_loops);
end