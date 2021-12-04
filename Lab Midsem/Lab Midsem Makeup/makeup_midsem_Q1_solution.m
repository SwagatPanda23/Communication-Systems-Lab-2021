
% m1(t) - DSB SC with Synchronous detector
% m2(t) - AM with envelope detector
clear
signal_duration = 5;

for T = 0:0.5:(signal_duration - 1)
    
    % defining the common parameters
    start_time = 0;
    stop_time = 0.5;
    fs = 100000; % Chosen such that it is greater than 5*max(f_carrier for B1, f_carrier for B2) = 9000
    ts = 1/fs;
    time = linspace(start_time, stop_time, fs);
    % Parameters mentioned in the problem statement
    Carrier_power = 18;
    A = sqrt(2*Carrier_power);
    
    len_time = length(time) ;
    freq_axis = linspace(-fs/2, fs/2, len_time);
    
    % Defining the message signal
    select = randi([1,2]);
    if(select == 1)
        B1 = 5;
        message_t = 2*B1*sinc(2*B1*(time - (start_time + stop_time)/2));
        message_f = fftshift(abs(fft(message_t)/fs));
        
        f_carrier = 9*B1;
        carrier_signal_t = A*cos(2*pi.*f_carrier.*time);
        carrier_signal_f = fftshift(abs(fft(carrier_signal_t)/fs));
        
        % Modulating the message signal
        message_mod_t = message_t.*carrier_signal_t;
        message_mod_f = fftshift(abs(fft(message_mod_t))/fs); 
        
    elseif(select == 2)
        B2 = 1000;
        message_t = 5 + sin(B2*pi*time);
        message_f = fftshift(abs(fft(message_t)/fs));
        
        f_carrier = 9*B2;
        carrier_signal_t = A*cos(2*pi.*f_carrier.*time);
        carrier_signal_f = fftshift(abs(fft(carrier_signal_t)/fs));
        
        % Modulating the message signal
        message_mod_t = (1 + message_t/A).*carrier_signal_t;
        message_mod_f = fftshift(abs(fft(message_mod_t))/fs);
        
    end
              
    % Modelling noise
    mu = 0;
    sigma_square = 2;
    sigma = sqrt(sigma_square);
    noise = mu + sigma * randn(1, numel(time));
   
    % Defining the channel - given to be a delta function
    K = 1; % constant associated with the channel
    output_t = K*message_mod_t ;%+ noise;
    output_f = fftshift(abs(fft(output_t)/fs));
   
    
    % demodulation
    if(select == 1)
         % The divide by A^2 factor is to account for the amplitude modification in 
         % the modulated message signal due to the carrier wave's
         % amplitude.
        B_LPF = 2*B1;
        output_predemod_t = (carrier_signal_t/A^2).*output_t;
        LPF_t = 2*B_LPF*sinc(2*B_LPF*(time - (start_time + stop_time) / 2));
        output_demod_t = conv(LPF_t, output_predemod_t,'same')/fs;

        output_predemod_f = conv(output_f, carrier_signal_f/A^2, 'same');
        LPF_f = rectpuls(freq_axis, 2*B_LPF);
        output_demod_f = output_predemod_f.*LPF_f;
   
    elseif(select == 2)
        % Subtraction of A to remove the DC value we added for the envelope
        % detector to work
        output_demod_t = abs(hilbert(output_t)) - A;
        output_demod_f = fftshift(abs(fft(output_demod_t)/fs));
    end
 
  
    figure(1)
    hold all
    subplot(3,1,1) 
    plot(time + T, message_t);
    title('Message signal time domain')
    xlabel('time(t)')
    ylabel('Amplitude')
    grid on
    hold on
    %axis([0  inf -2 2]) 
   
    subplot(3,1,2)
    plot(time + T, message_mod_t)
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
   
    figure(2)
    subplot(3,1,1)
    plot(freq_axis, message_f)
    title('Message signal frequency domain')
    xlabel('Frequency (Hz)')
    ylabel('Magnitude')
    grid on
    hold on
    % axis([-35 35 0 0.6])
    
    subplot(3,1,2)
    plot(freq_axis, message_mod_f)
    title('Modulated signal frequency domain')
    xlabel('Frequency (Hz)')
    ylabel('Magnitude')
    grid on
    hold on
    % axis([-600 600 0 0.6])
   
    subplot(3,1,3)
    plot(freq_axis, output_demod_f)
    title('Demodulated signal frequency domain')
    xlabel('Frequency (Hz)')
    ylabel('Magnitude')
    grid on
    hold on
    % axis([-35 35 0 inf])
    
end
