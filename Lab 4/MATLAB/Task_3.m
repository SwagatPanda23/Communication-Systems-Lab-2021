clear
close all
duration_signal = 30;
A = 1;
last_digit_id = 3;
f1 = randi([10,100]);
f2 = randi([10,100]);

for T = 0:(duration_signal - 1)  % Duration 30 seconds with interval of 1 sec.
    if (T == 0)
        disp('Transmission Started')
        disp(T)
    elseif(T == duration_signal - 1)
        disp('Transmission ends: see the final result')
        disp(T)
    else
        disp('Transmission in progress: please wait')
        disp(T)
    end
    
    freq_max = 100;             % Max possible frequency content goes here.
    fs = 10*freq_max;
    ts = 1/fs;
    t_start = 0;
    t_stop = 1;
    t = t_start:ts:t_stop;
    
    message_t = last_digit_id*cos(2*pi*f1*t) + last_digit_id*cos(2*pi*f2*t);  
    N = length(message_t);
    message_f = fftshift(abs(fft(message_t, N)/fs));
    
    freqaxis = linspace(-fs/2, fs/2, N);
    
    B = 50;
    channel_t = 2*B*sinc(2*B*(t - (t_start + t_stop)/2));
    % channel_f = fftshift(abs(fft(channel_t, N)/fs));
    channel_f = rectpuls(freqaxis, 2*B);
    % Either of the two channel_f definitions can be used, the results
    % would be identical. 
    
    output_f = message_f.*channel_f;
    output_t = conv(message_t,channel_t,'same')/fs;
    
    figure(1)
    hold all  % Keeps the previous plots and everytime changes the color
    
    subplot(2,1,1)
    plot(t + T, output_t)
    title('Time domain: Message signal')
    xlabel('time')
    ylabel('amplitude')
    grid on
    % axis([0  inf -5 5])   % First two are limits for x-axis, the other two are limits for y-axis: observe why 0 inf , and -5 5 are used here.
    hold on     % Keeps the previous plots 
    
    subplot(2,1,2)
    plot(freqaxis,output_f)
    title('Frequency domain: Message signal')
    xlabel('frequency (Hz)')
    ylabel('Magnitude')
    grid on
    hold on
    % axis([-100 100 0 inf])  % First two are limits for x-axis, the other two are limits for y-axis: observe why -inf inf , and 0 3 are used here. 
     
    % pause(2)  % Pauses for 2 seconds and then go for next loop increment.
end

hold off
