clear

[message,fs] = audioread('happy.wav');
signal_duration = floor(length(message)/fs);
message_recieved = message;

for T = 0:(signal_duration - 1)
    
    % defining the common parameters
    
    start_time = 0;
    stop_time = 1;
    f_carrier = 20000;
    ts = 1/fs;
    time = linspace(start_time,stop_time,fs);
    A = 2;
    carrier_signal_t = A*cos(2*pi.*f_carrier.*time);
    carrier_signal_f = fftshift(abs(fft(carrier_signal_t)/fs));
    
    len_time = length(time) ;
    freq_axis = linspace(-fs/2,fs/2, len_time);
    
    % Defining the message signal
    message_t_left = message((fs*(T)+1):(fs*(T+1)),1).';
    message_f_left = fftshift(abs(fft(message_t_left)/fs));
    message_t_right = message((fs*(T)+1):(fs*(T+1)),2).';
    message_f_right = fftshift(abs(fft(message_t_right)/fs));
    
    % Modulating the message signal
    message_mod_t_left = (1 + message_t_left/A).*carrier_signal_t;
    message_mod_f_left = fftshift(abs(fft(message_mod_t_left))/fs);
    
    message_mod_t_right = (1 + message_t_right/A).*carrier_signal_t;
    message_mod_f_right = fftshift(abs(fft(message_mod_t_right))/fs);
    
   
    % Defining the channel - Consider a non distorting channel (delta function in time domain) for
    % simplicity as the question doesn't mention anything about it.
    K = 1;
    output_t_left = K*message_mod_t_left;
    output_t_right = K*message_mod_t_right;
    
    
    % demodulation
    % Subtraction of A to remove the DC value we added for the envelope detector to work.
    output_demod_t_left = abs(hilbert(output_t_left)) - A;
    output_demod_f_left = fftshift(abs(fft(output_demod_t_left)/fs));
    
    output_demod_t_right = abs(hilbert(output_t_right)) - A;
    output_demod_f_right = fftshift(abs(fft(output_demod_t_right)/fs));
    
    message_received((fs*(T)+1):(fs*(T+1)),1) = output_demod_t_left';
    message_received((fs*(T)+1):(fs*(T+1)),2) = output_demod_t_right';
    
    
    figure(1)
    hold all
    subplot(3,1,1) 
    plot(time + T, message_t_left);
    title('Message signal time domain')
    xlabel('time(t)')
    ylabel('Amplitude')
    grid on
    hold on
    %axis([0  inf -2 2]) 
   
    subplot(3,1,2)
    plot(time + T, message_mod_t_left)
    title('Modulated signal time domain')
    xlabel('time(t)')
    ylabel('Amplitude')
    hold on
    grid on
    % xlim([0, 0.1])
    
    subplot(3,1,3)
    plot(time + T, output_demod_t_left)
    title('Demodulated signal time domain')
    xlabel('time(t)')
    ylabel('Amplitude')
    hold on
    grid on
   
    figure(2)
    subplot(3,1,1)
    plot(freq_axis, message_f_left)
    title('Message signal frequency domain')
    xlabel('Frequency (Hz)')
    ylabel('Magnitude')
    grid on
    hold on
    % axis([-35 35 0 0.6])
    
    subplot(3,1,2)
    plot(freq_axis, message_mod_f_left)
    title('Modulated signal frequency domain')
    xlabel('Frequency (Hz)')
    ylabel('Magnitude')
    grid on
    hold on
    % axis([-600 600 0 0.6])
   
    subplot(3,1,3)
    plot(freq_axis, output_demod_f_left)
    title('Demodulated signal frequency domain')
    xlabel('Frequency (Hz)')
    ylabel('Magnitude')
    grid on
    hold on
    % axis([-35 35 0 inf])
    
end

sound(message_received, fs)
