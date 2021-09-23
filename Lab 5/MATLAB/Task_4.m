clear

[message,fs] = audioread('Music.wav');
time_endpt = floor(length(message)/fs);
message_noisy = message;

for T = 0:time_endpt - 1

    % Defining all the common parameters for each second
    start_time = 0;
    stop_time = 1;
    ts = 1/fs;
    time = start_time:ts:stop_time;

    % Generating the message signal
    message_t_left = message((fs*(T)+1):(fs*(T+1)+1),1);
    message_t_right = message((fs*(T)+1):(fs*(T+1)+1),2);

    figure(1)
    subplot(1,2,1)
    plot(time + T, message_t_left)
    title('Message - Time Domain')
    xlabel('Time')
    ylabel('Amplitude')
    hold on
    
    subplot(1,2,2)
    plot(time + T, message_t_right)
    title('Message, Right - Time Domain')
    xlabel('Time')
    ylabel('Amplitude')
    hold on
    
    % Modelling the Channel
    % The bandwidth should be sufficiently large to encompass all the
    % frequencies within the music sample.
    B = 20000;
    channel_t = 2*B*sinc(2*pi*B*(time - (- start_time + stop_time)/2));
    
    % Modelling noise
    mu = 0;  % Sum of last two digits of ID
    sigma_square = 5;  % Sum of last three digits of ID
    sigma = sqrt(sigma_square);

    noise = mu + sigma * randn(numel(message_t_left),1);
    
    % There can be two implementations to this which work - when using the
    % following segment, uncomment the delta function implementation.
    output_t_left = conv(message_t_left, channel_t,'same')/fs + 0.01*noise;
    output_t_right = conv(message_t_right, channel_t,'same')/fs + 0.01*noise;
    
    message_noisy((fs*(T)+1):(fs*(T+1)+1), 1) = output_t_left;
    message_noisy((fs*(T)+1):(fs*(T+1)+1), 2) = output_t_right;
    
    figure(2)
    subplot(1,2,1)
    plot(time + T, output_t_left)
    title('Output, Left - Time Domain')
    xlabel('Time')
    ylabel('Amplitude')
    hold on
    
    subplot(1,2,2)
    plot(time + T, output_t_right)
    title('Output, Right - Time Domain')
    xlabel('Time')
    ylabel('Amplitude')
    hold on
end
% sound(message_noisy, fs)
filename = 'Noisy Message.wav';
audiowrite(filename,message_noisy,fs)
