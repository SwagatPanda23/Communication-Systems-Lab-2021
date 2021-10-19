clear

[message,fs] = audioread('Music.wav');
signal_duration = floor(length(message)/fs);
message_noisy = message;

for T = 0:(signal_duration - 1)
    
    % defining the common parameters
    start_time = 0;
    stop_time = 1;
    f_carrier = 10*10^3;
    ts = 1/fs;
    time = start_time:ts:stop_time;
    A = 10;
    carrier_signal_t = A*cos(2*pi.*f_carrier.*(time - (start_time + stop_time) / 2));
    carrier_signal_f = fftshift(abs(fft(carrier_signal_t)/fs));
    kf = 100;
    
    len_time = length(time) ;
    freq_axis = linspace(-fs/2,fs/2, len_time);
    
    % Defining the message signal
    message_t_left = message((fs*(T)+1):(fs*(T+1)+1),1).';
    message_f_left = fftshift(abs(fft(message_t_left)/fs));
    message_t_right = message((fs*(T)+1):(fs*(T+1)+1),2).';
    message_f_right = fftshift(abs(fft(message_t_right)/fs));
    m_integrate_left = ts.*cumsum(message_t_left);
    m_integrate_right = ts.*cumsum(message_t_right);
    
    % Modulating the message signal
    message_mod_t_left = A*cos(2*pi*f_carrier.*time + kf*m_integrate_left);
    message_mod_f_left = fftshift(abs(fft(message_mod_t_left))/fs);
    message_mod_t_right = A*cos(2*pi*f_carrier.*time + kf*m_integrate_right);
    message_mod_f_right = fftshift(abs(fft(message_mod_t_right))/fs);
    
    % Modelling noise
    mu = 0;
    sigma_square = 10^(-2); % Noise variance was reduced because the value in the problem made the audio very very noisy
    sigma = sqrt(sigma_square);
    noise = mu + sigma * randn(1,numel(time));
    
    % Modelling the Channel
    f_channel = f_carrier;
    G_t = 100;
    G_r = 100;
    c = 3*10^8;
    d = 1000; % in meters
    a = sqrt((G_t*G_r*c^2)/((4*pi*f_channel*d)^2));
   
    % Both of the following implementations work - uncomment any one at a
    % time
    % 1. Implement the delta function
    channel_t1 = dirac(time - (start_time + stop_time)/2);
    idx = channel_t1 == Inf; % find Inf 
    channel_t1(idx) = a;     % set Inf to finite value 
    channel_t = channel_t1.*carrier_signal_t;
     
    output_t_left = conv(message_mod_t_left, channel_t, 'same') + noise;
    output_f_left = fftshift(abs(fft(output_t_left)/fs));
    output_t_right = conv(message_mod_t_right, channel_t, 'same') + noise;
    output_f_right = fftshift(abs(fft(output_t_right)/fs));
    
    % 2. Instead of convolivng with the delta function, directly multiply
    % the output with the amplituude of channel_t, for which I have used
    % 'a' here.
    
    % output_t = a.*message_mod_t;
    % output_f = fftshift(abs(fft(output_t)/fs));
   
    
     % demodulation 
     
      method = 1;
    % demodulation - Method 1
    if (method == 1)
        output_predemod_t_left = diff(output_t_left)/(ts*kf);
        output_demod_t_left = abs(hilbert(output_predemod_t_left)) - mean(abs(hilbert(output_predemod_t_left)));
        output_demod_f_left = fftshift(abs(fft(output_demod_t_left)/fs));
        
        output_predemod_t_right = diff(output_t_right)/(ts*kf);
        output_demod_t_right = abs(hilbert(output_predemod_t_right)) - mean(abs(hilbert(output_predemod_t_right)));
        output_demod_f_right = fftshift(abs(fft(output_demod_t_right)/fs));
        
        message_noisy((fs*(T)+1):(fs*(T+1)), 1) = output_demod_t_left;
        message_noisy((fs*(T)+1):(fs*(T+1)), 2) = output_demod_t_right;
    elseif(method == 2)
        % Method 2 - This would produce some ringing at the end of each
        % second due to the limitations of the method used
        output_predemod_t_left = hilbert(output_t_left); %form the analytical signal from the received vector
        inst_phase_left = unwrap(angle(output_predemod_t_left)); %instaneous phase
        
        output_predemod_t_right = hilbert(output_t_right); %form the analytical signal from the received vector
        inst_phase_right = unwrap(angle(output_predemod_t_right)); %instaneous phase
        
        %If receiver don't know the carrier, estimate the subtraction term
        receiverKnowsCarrier = 'False';
        if strcmpi(receiverKnowsCarrier,'True')
            offsetTerm_left = 2*pi*f_carrier*time; %if carrier frequency & phase offset is known
            output_demod_t_left = diff( inst_phase_left - offsetTerm_left) / (kf*ts);
            
            offsetTerm_right = 2*pi*f_carrier*time; %if carrier frequency & phase offset is known
            output_demod_t_right = diff(inst_phase_right - offsetTerm_right) / (kf*ts);
        else
            p_left = polyfit(time,inst_phase_left,1); %linearly fit the instaneous phase
            estimated_left = polyval(p_left,time); %re-evaluate the offset term using the fitted values
            offsetTerm_left = estimated_left;
            output_demod_t_left = diff(inst_phase_left - offsetTerm_left) / (kf*ts);
            
            p_right = polyfit(time,inst_phase_right,1); %linearly fit the instaneous phase
            estimated_right = polyval(p_right,time); %re-evaluate the offset term using the fitted values
            offsetTerm_right = estimated_right;
            output_demod_t_right = diff(inst_phase_right - offsetTerm_right) / (kf*ts);
        end
        
        output_demod_f_left = fftshift(abs(fft(output_demod_t_left)/fs));
        output_demod_f_right = fftshift(abs(fft(output_demod_t_right)/fs));
        
        message_noisy((fs*(T)+1):(fs*(T+1)), 1) = output_demod_t_left';
        message_noisy((fs*(T)+1):(fs*(T+1)), 2) = output_demod_t_right';
    end
    
    
    % Plotting only the left channel - Right can also be done with
    % identical results
    figure(1)
    hold all
    subplot(5,1,1) 
    plot(time + T, message_t_left);
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
    plot(time + T, message_mod_t_left)
    title('Modulated signal time domain')
    xlabel('time(t)')
    ylabel('Amplitude')
    hold on
    grid on
    
    subplot(5,1,4)
    plot(time + T, output_t_left)
    title('Modulated signal after the channel time domain')
    xlabel('time(t)')
    ylabel('Amplitude')
    hold on
    grid on
    
    subplot(5,1,5)
    plot(time(5:end - 4) + T, output_demod_t_left(4:end - 4))
    title('Demodulated signal time domain')
    xlabel('time(t)')
    ylabel('Amplitude')
    % axis([-inf inf -1 1])
    hold on
    grid on
   
    figure(2)
    subplot(5,1,1)
    plot(freq_axis, message_f_left)
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
    plot(freq_axis, message_mod_f_left)
    title('Modulated signal frequency domain')
    xlabel('Frequency (Hz)')
    ylabel('Magnitude')
    grid on
    hold on
    % axis([-600 600 0 0.6])
    
    subplot(5,1,4)
    plot(freq_axis, output_f_left)
    title('Modulated signal after the channel frequency domain')
    xlabel('Frequency (Hz)')
    ylabel('Magnitude')
    grid on
    hold on
    % axis([-600 600 0 0.6])
   
    subplot(5,1,5)
    plot(freq_axis(2:end), output_demod_f_left)
    title('Demodulated signal frequency domain')
    xlabel('Frequency (Hz)')
    ylabel('Magnitude')
    grid on
    hold on
    % axis([-35 35 0 inf])
    
end

sound(message_noisy/max(message_noisy), fs)
% filename = 'Noisy Message.wav';
% audiowrite(filename, message_noisy/max(mesage_noisy), fs)