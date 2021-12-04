clear
% NOTE - WE ARE USING THE 
f_carrier = 10^5;
fs = 5*f_carrier;
    
signal_duration = 7;
time_s = linspace(0,signal_duration, signal_duration*fs);
% Defining the message signal
fr1 = 440;
fr2 = 480;

% noisy frequency - 1000 Hz - IF REQUIRED, ONE CAN USE THE SIGNAL OBTAINED
% FROM PART a DIRECTLY
fr3 = 1000;
ring_tone_t = 0.1*sin(2*pi*fr1*time_s) + 0.1*sin(2*pi*fr2*time_s) + 0.1*sin(2*pi*fr3*time_s);
ring_tone_f = fftshift(abs(fft(ring_tone_t)/fs));

% Loop to set the Cadence for 2 seconds ON and then 4 seconds OFF 
for i = 1:1:signal_duration - 1
    if((mod(i,6) == 2)||(mod(i,6) == 3)||(mod(i,6) == 4)||(mod(i,6) == 5))
        ring_tone_t(i*fs:((i+1)*fs-1)) = 0;
    else 
        ring_tone_t(i*fs:((i+1)*fs-1)) = ring_tone_t(i*fs:((i+1)*fs-1));
    end
end

for T = 0:(signal_duration - 1)
    
    % defining the common parameters
    
    start_time = 0;
    stop_time = 1;
    ts = 1/fs;
    time = linspace(start_time, stop_time, fs);
    A = 2;
    carrier_signal_t = A*cos(2*pi.*f_carrier.*time);
    carrier_signal_f = fftshift(abs(fft(carrier_signal_t)/fs));
    
    len_time = length(time) ;
    freq_axis = linspace(-fs/2,fs/2, len_time);
    
    message_t = ring_tone_t(T*fs + 1:(T+1)*fs);
    message_f = fftshift(abs(fft(message_t)/fs));
    
    % Modulating the message signal
    % Single Sideband Signal - the following is for USSB generation. If the - sign is replaced
    % with a + sign, we get the LSSB signal.
    
    message_mod_ssb_t = message_t.*cos(2*pi*f_carrier.*time) - imag(hilbert(message_t).*sin(2*pi*f_carrier.*time));
    message_mod_ssb_f = fftshift(abs(fft(message_mod_ssb_t)/fs));
   
    % Defining the channel - Multiplied with carrier to shift it to the carrier frequency.
    P_t = 10^6; % Transmit power - Chosen such that the value of K is not too low.
    d = 3*(3*10^8)/f_carrier; % distance is greater than lambda_carrier ( we considered 3x of lambda_carrier, but anything >= 2 times works)
    K = P_t/d^2;
    
    % 2. Instead of convolivng with the delta function, directly multiply
    % the output with the amplituude of channel_t, for which I have used
    % 'K' here.
    
    output_t = K.*message_mod_ssb_t;
    output_f = fftshift(abs(fft(output_t)/fs));

    % demodulation 
    
    % I did not use Hilbert based envelope detector demodulation for SSB
    % because it is very inefficient -- https://www.ee.ryerson.ca/~lzhao/ELE635/Chap3_AM-notes%20Part%202.pdf
    
    B_LPF = 2*f_carrier;
    output_predemod_t = (carrier_signal_t).*output_t;
    LPF_t = 2*B_LPF*sinc(2*B_LPF*(time - (start_time + stop_time)/2));
    output_demod_t = conv(LPF_t, output_predemod_t,'same')/fs;

    output_demod_f = fftshift(abs(fft(output_demod_t)/fs));
    
    
    figure(1)
    hold all
    subplot(3,1,1) 
    plot(time + T, message_t);
    title('Message signal time domain')
    xlabel('time(t)')
    ylabel('Amplitude')
    grid on
    hold on
    % xlim([0, 0.1]) 
   
    subplot(3,1,2)
    plot(time + T, message_mod_ssb_t)
    title('Modulated signal time domain')
    xlabel('time(t)')
    ylabel('Amplitude')
    hold on
    grid on
    % xlim([0, 0.1])
    
    subplot(3,1,3)
    plot(time + T, output_demod_t)
    title('Demodulated signal time domain')
    xlabel('time(t)')
    ylabel('Amplitude')
    hold on
    grid on
    % xlim([0, 0.1])
    
    figure(2)
    subplot(3,1,1)
    plot(freq_axis, message_f)
    title('Message signal frequency domain')
    xlabel('Frequency (Hz)')
    ylabel('Magnitude')
    grid on
    hold on
    axis([-2*fr3 2*fr3 0 inf])
    
    subplot(3,1,2)
    plot(freq_axis, message_mod_ssb_f)
    title('Modulated signal frequency domain')
    xlabel('Frequency (Hz)')
    ylabel('Magnitude')
    grid on
    hold on
    axis([-2*f_carrier 2*f_carrier 0 inf])
   
    subplot(3,1,3)
    plot(freq_axis, output_demod_f)
    title('Demodulated signal frequency domain')
    xlabel('Frequency (Hz)')
    ylabel('Magnitude')
    grid on
    hold on
    axis([-2*fr3 2*fr3 0 inf])
    
end