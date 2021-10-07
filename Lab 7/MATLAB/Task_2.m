clear

signal_duration = 10;

for T = 0:(signal_duration - 1)
    
    % defining the common parameters
    
    N = 11; % Sum of last 3 digits of ID
    
    start_time = 0;
    stop_time = 1;
    f_carrier = 500;
    fs = 10*f_carrier;
    ts = 1/fs;
    time = start_time:ts:stop_time;
    A = 25;
    carrier_signal_t = A*cos(2*pi.*f_carrier.*time);
    carrier_signal_f = fftshift(abs(fft(carrier_signal_t)/fs));
    
    len_time = length(time) ;
    freq_axis = linspace(-fs/2,fs/2, len_time);
    
    % Defining the message signal
    B = randi([1,5]); 
    message_t = 20*B*sinc(20*B.*(time - (start_time + stop_time)/2));
    message_f = fftshift(abs(fft(message_t)/fs));
    
    % Modulating the message signal
    message_mod_t = (1 + message_t/A).*carrier_signal_t;
    message_mod_f = fftshift(abs(fft(message_mod_t))/fs);
    
    % Modelling noise
    mu = 0;
    sigma_square = 0.001;
    sigma = sqrt(sigma_square);
    noise = mu + sigma * randn(1, numel(time));
   
    % Modelling the Channel
    f_channel = f_carrier;
    G_t = 0.1;
    G_r = 0.1;
    c = 3*10^8;
    d = 10^4; % in meters
    a = sqrt((G_t*G_r*c^2)/((4*pi*f_channel*d)^2));
    

    % Both of the following implementations work - uncomment any one at a
    % time
    % 1. Implement the delta function
    channel_t1 = dirac(time - (start_time + stop_time)/2);
    idx = channel_t1 == Inf; % find Inf 
    channel_t1(idx) = a;     % set Inf to finite value 
    channel_t = channel_t1.*carrier_signal_t/A;
     
    output_t = conv(message_mod_t, channel_t, 'same') + noise;
    output_f = fftshift(abs(fft(output_t)/fs));
    
    % 2. Instead of convolivng with the delta function, directly multiply
    % the output with the amplituude of channel_t, for which I have used
    % 'a' here.
    
    % output_t = a.*message_mod_t;
    % output_f = fftshift(abs(fft(output_t)/fs));
   
    
    % demodulation - division by 2 to ensure that the amplitude of the
    % carrier which has been multiplied before is reduced to 1.
    
    % Subtraction of A *a to remove the DC value (which was modified by the channel) we added for the envelope
    % detector to work
    output_demod_t = abs(hilbert(output_t)) - A*a;
    output_demod_f = fftshift(abs(fft(output_demod_t)/fs));
 
  
    figure(1)
    hold all
    subplot(5,1,1) 
    plot(time + T, message_t);
    title('Message signal time domain')
    xlabel('time(t)')
    ylabel('Amplitude')
    grid on
    hold on
    %axis([0  inf -2 2]) 
   
    subplot(5,1,2)
    plot(time + T, carrier_signal_t)
    title('Carrier signal time domain')
    xlabel('time(t)')
    ylabel('Amplitude')
    hold on
    grid on
    % xlim([0, 0.1])
    
    subplot(5,1,3)
    plot(time + T, message_mod_t)
    title('Modulated signal time domain')
    xlabel('time(t)')
    ylabel('Amplitude')
    hold on
    grid on
    
    subplot(5,1,4)
    plot(time + T, output_t)
    title('Modulated signal after the channel time domain')
    xlabel('time(t)')
    ylabel('Amplitude')
    hold on
    grid on
    
    subplot(5,1,5)
    plot(time + T, output_demod_t)
    title('Demodulated signal time domain')
    xlabel('time(t)')
    ylabel('Amplitude')
    hold on
    grid on
   
    figure(2)
    subplot(5,1,1)
    plot(freq_axis, message_f)
    title('Message signal frequency domain')
    xlabel('Frequency (Hz)')
    ylabel('Magnitude')
    grid on
    hold on
    % axis([-35 35 0 0.6])
    
    subplot(5,1,2)
    plot(freq_axis, carrier_signal_f)
    title('Carrier signal frequency domain')
    xlabel('Frequency (Hz)')
    ylabel('Magnitude')
    grid on
    hold on
    % axis([-600 600 0 0.6])
    
    subplot(5,1,3)
    plot(freq_axis, message_mod_f)
    title('Modulated signal frequency domain')
    xlabel('Frequency (Hz)')
    ylabel('Magnitude')
    grid on
    hold on
    % axis([-600 600 0 0.6])
    
    subplot(5,1,4)
    plot(freq_axis, output_f)
    title('Modulated signal after the channel frequency domain')
    xlabel('Frequency (Hz)')
    ylabel('Magnitude')
    grid on
    hold on
    % axis([-600 600 0 0.6])
   
    subplot(5,1,5)
    plot(freq_axis, output_demod_f)
    title('Demodulated signal frequency domain')
    xlabel('Frequency (Hz)')
    ylabel('Magnitude')
    grid on
    hold on
    % axis([-35 35 0 inf])
    
end