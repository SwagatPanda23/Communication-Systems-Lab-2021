clear

[message,fs] = audioread('Music.wav');
signal_duration = floor(length(message)/fs);
message_noisy = message;

for T = 0:signal_duration - 1
    
    % defining the common parameters
    start_time = 0;
    stop_time = 1;
    f_carrier = 12500;
    ts = 1/fs;
    time = start_time:ts:stop_time;
    carrier_signal_t = 2*cos(2*pi.*f_carrier.*(time - (start_time + stop_time) / 2));
    carrier_signal_f = fftshift(abs(fft(carrier_signal_t)/fs));
    
    len_time = length(time) ;
    freq_axis = linspace(-fs/2,fs/2, len_time);
    
    % Defining the message signal
    message_t_left = message((fs*(T)+1):(fs*(T+1)+1),1).';
    message_f_left = fftshift(abs(fft(message_t_left)/fs));
    message_t_right = message((fs*(T)+1):(fs*(T+1)+1),2).';
    message_f_right = fftshift(abs(fft(message_t_right)/fs));
    
    % Modulating the message signal
    message_mod_t_left = message_t_left .*carrier_signal_t;
    message_mod_f_left = fftshift(abs(fft(message_mod_t_left))/fs);
    message_mod_t_right = message_t_right .*carrier_signal_t;
    message_mod_f_right = fftshift(abs(fft(message_mod_t_right))/fs);
    
    % Modelling noise
    mu = 0;
    sigma_square = 0.01;
    sigma = sqrt(sigma_square);
    noise = mu + sigma * randn(numel(time),1);
   
    % Defining the channel - Multiplied with carrier to shift it to the carrier frequency.
    B = 10000;
    channel_t = 2*B*sinc(2*B*(time - (start_time + stop_time) / 2)).*carrier_signal_t;
    
    output_t_left = conv(message_mod_t_left,channel_t,'same')/fs + noise.';
    output_f_left = fftshift(abs(fft(output_t_left)/fs));
    output_t_right = conv(message_mod_t_right,channel_t,'same')/fs + noise.';
    output_f_right = fftshift(abs(fft(output_t_right)/fs));
   
    
    % demodulation
    B_LPF = 10000;
    output_predemod_t_left = (carrier_signal_t/2).*output_t_left;
    LPF_t = 2*B_LPF*sinc(2*B_LPF*(time - (start_time + stop_time) / 2));
    output_demod_t_left = conv(LPF_t, output_predemod_t_left,'same')/fs;

    output_predemod_f_left = conv(output_f_left, carrier_signal_f/2, 'same');
    LPF_f = rectpuls(freq_axis, 2*B_LPF);
    output_demod_f_left = output_predemod_f_left.*LPF_f;
    
    output_predemod_t_right = (carrier_signal_t/2).*output_t_right;
    output_demod_t_right = conv(LPF_t, output_predemod_t_right,'same')/fs;

    output_predemod_f_right = conv(output_f_right, carrier_signal_f/2, 'same');
    output_demod_f_right = output_predemod_f_right.*LPF_f;
    
    message_noisy((fs*(T)+1):(fs*(T+1)+1), 1) = output_demod_t_left;
    message_noisy((fs*(T)+1):(fs*(T+1)+1), 2) = output_demod_t_right;
    
    % Plotting only the left channel - Right can also be done with
    % identical results
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
% sound(message_noisy, fs)
filename = 'Noisy Message.wav';
audiowrite(filename,message_noisy,fs)
