clear

%% Generating Dial Tone

signal_duration = 15;
fs = 10000;
t = 0:1/fs:signal_duration;
N = length(t);
freq = linspace(-fs/2, fs/2, N);

fd1 = 440;
fd2 = 350;

dial_tone_t = 0.1*sin(2*pi*fd1*t) + 0.1*sin(2*pi*fd2*t);
dial_tone_f = fftshift(abs(fft(dial_tone_t)/fs));

% sound(dial_tone_t,fs)

filename = 'dial_tone.wav';
audiowrite(filename,dial_tone_t,fs);

figure(1)

subplot(2,1,1)
plot(t, dial_tone_t)
title("Time Domain Plot - Dial Tone")
xlabel("Time(s)")
ylabel("Amplitude")
axis([0 0.5 -0.3 0.3]) 
grid on

subplot(2,1,2)
plot(freq, dial_tone_f)
title("Frequency Domain Plot - Dial Tone")
xlabel("Frequency(Hz)")
ylabel("Amplitude")
axis([-inf inf 0 inf]) 
grid on

%% FM Modulation, Transmission and subsequent Demodulation of Dial Tone
for T = 0:(signal_duration - 1)
    
    % defining the common parameters
    start_time = 0;
    stop_time = 1;
    f_carrier = 10^3; % Ensure that f_carrier < fs
    ts = 1/fs;
    time = start_time:ts:stop_time;
    A = 2;
    carrier_signal_t = A*cos(2*pi.*f_carrier.*(time - (start_time + stop_time) / 2));
    carrier_signal_f = fftshift(abs(fft(carrier_signal_t)/fs));
    kf = 10;
    
    len_time = length(time) ;
    freq_axis = linspace(-fs/2,fs/2, len_time);
    
    % Defining the message signal
    message_t = dial_tone_t((fs*(T)+1):(fs*(T+1)+1));
    message_f = fftshift(abs(fft(message_t)/fs));
    m_integrate = ts.*cumsum(message_t);
    
    % Modulating the message signal
    message_mod_t = A*cos(2*pi*f_carrier.*time + kf*m_integrate);
    message_mod_f = fftshift(abs(fft(message_mod_t))/fs);
    
    % Modelling the Channel - Distortionless
    K = 1; % K can be any constant value, but in order to be 
    % distortionless it has to be a delta function in time domain.
   
    % Both of the following implementations work - uncomment any one at a
    % time.
    % 1. Implement the delta function
    channel_t1 = dirac(time - (start_time + stop_time)/2);
    idx = channel_t1 == Inf; % find Inf 
    channel_t1(idx) = K;     % set Inf to finite value 
    channel_t = channel_t1;
    
    output_t = conv(message_mod_t, channel_t, 'same');
    output_f = fftshift(abs(fft(output_t)/fs));
    
    % 2. Instead of convolivng with the delta function, directly multiply
    % the output with the amplituude of channel_t, for which I have used
    % 'K' here.
    
    % output_t = K.*message_mod_t;
    % output_f = fftshift(abs(fft(output_t)/fs));
   
    
    % demodulation 
    % demodulation - Method 1
    output_predemod_t = diff(output_t)/(ts*kf*A); % A to compensate for the amplitude that remains after differentiation.
    output_demod_t = abs(hilbert(output_predemod_t)) - mean(abs(hilbert(output_predemod_t)));
    output_demod_f = fftshift(abs(fft(output_demod_t)/fs));

    message_received((fs*(T)+1):(fs*(T+1))) = output_demod_t;
    
    
    % Plotting only the left channel - Right can also be done with
    % identical results

    figure(2)
    subplot(3,1,1)
    plot(time + T, message_mod_t)
    title('Modulated signal time domain')
    xlabel('time(t)')
    ylabel('Amplitude')
    hold on
    grid on
    
    subplot(3,1,2)
    plot(time + T, output_t)
    title('Modulated signal after the channel time domain')
    xlabel('time(t)')
    ylabel('Amplitude')
    hold on
    grid on
    
    subplot(3,1,3)
    plot(time(5:end - 4) + T, output_demod_t(4:end - 4))
    title('Demodulated signal time domain')
    xlabel('time(t)')
    ylabel('Amplitude')
    % axis([-inf inf -1 1])
    hold on
    grid on
   
    figure(3)
    
    subplot(3,1,1)
    plot(freq_axis, message_mod_f)
    title('Modulated signal frequency domain')
    xlabel('Frequency (Hz)')
    ylabel('Magnitude')
    grid on
    hold on
    % axis([-600 600 0 0.6])
    
    subplot(3,1,2)
    plot(freq_axis, output_f)
    title('Modulated signal after the channel frequency domain')
    xlabel('Frequency (Hz)')
    ylabel('Magnitude')
    grid on
    hold on
    % axis([-600 600 0 0.6])
   
    subplot(3,1,3)
    plot(freq_axis(2:end), output_demod_f)
    title('Demodulated signal frequency domain')
    xlabel('Frequency (Hz)')
    ylabel('Magnitude')
    grid on
    hold on
    % axis([-35 35 0 inf])
    
end

sound(message_received/max(message_received), fs)

