clear

time_endpt = 30;

for T = 1:time_endpt

    % Defining all the common parameters for each second
    start_time = 0;
    stop_time = 1;
    B = 10;
    fs = 10*B;
    ts = 1/fs;
    time = start_time:ts:stop_time;

    % Generating the message signal
    message_t = 2 * B * sinc(2 * pi * B * (time - (start_time + stop_time)/2));

    % Modelling the Channel
    a = 0.5;  % a is less than 1

    % Both of the following implementations work
    % Implement the delta function
    channel_t = dirac(time - (start_time + stop_time)/2);
    idx = channel_t == Inf; % find Inf 
    channel_t(idx) = 1;     % set Inf to finite value 
    
    % Or directly multiply message_t with a because convolution with a
    % delta function is a well known result

    figure(1)
    plot(time + T, message_t)
    title('Message - Time Domain')
    xlabel('Time')
    ylabel('Amplitude')
    hold on

    % Modelling noise
    mu = 0;  % Sum of last two digits of ID
    sigma_square = 5;  % Sum of last three digits of ID
    sigma = sqrt(sigma_square);

    noise = mu + sigma * randn(numel(message_t),1);
    
    % The noise amplitude can be adjusted accordingly
    output_t = conv(message_t', channel_t,'same')./fs + 0.01*noise;
    % output_t = a*message_t + noise
    
    figure(2)
    plot(time + T, output_t)
    title('Output - Time Domain')
    xlabel('Time')
    ylabel('Amplitude')
    hold on
end

