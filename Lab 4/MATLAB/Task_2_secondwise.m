clear
close all
duration_signal = 30;
A = 1;
last_digit_id = 3;

for T = 0:(duration_signal - 1)  % Duration 30 seconds with interval of 1 sec.
    rand_num = randi(4);
    if rand_num <= 3
            if (T == 0)
                disp('Transmission Started')
                disp(T)
            elseif(T == duration_signal) 
                disp('Transmission ends: see the final result')
                disp(T)
            else
                disp('Transmission in progress: please wait')
                disp(T)
            end

            freq = last_digit_id; % Last digit of the ID number goes here

            fs = 10*freq;
            ts = 1/fs;
            t_start = 0;
            t_stop = 1;
            t = t_start:ts:t_stop;

            if rand_num == 1
                message_t = cos(2*pi*freq.*t); 
            elseif rand_num == 2
                message_t = 2*freq*sinc(2*pi*freq.*(t - (t_start + t_stop)/2));
            elseif rand_num == 3
                message_t = rectpuls((t - (t_start + t_stop)/2), freq); 
            else

            end        

            N = length(message_t);
            message_f = fft(message_t, N)/fs;
            freqaxis = linspace(-fs/2, fs/2, N);

            figure(1)
            hold all  % Keeps the previous plots and everytime changes the color

            subplot(2,1,1)
            plot(t + T, message_t)
            title('Time domain: Message signal')
            xlabel('time')
            ylabel('amplitude')
            grid on
            axis([0  inf -5 5])   % First two are limits for x-axis, the other two are limits for y-axis: observe why 0 inf , and -5 5 are used here.
            hold on     % Keeps the previous plots 

            subplot(2,1,2)
            plot(freqaxis, fftshift(abs(message_f)))
            title('Frequency domain: Message signal')
            xlabel('frequency (Hz)')
            ylabel('Magnitude')
            grid on
            hold on
            % axis([-10000 10000 -inf inf])  % First two are limits for x-axis, the other two are limits for y-axis: observe why -inf inf , and 0 3 are used here. 

            % pause(2)  % Pauses for 2 seconds and then go for next loop increment.
    else
        [data,fs] = audioread('Music.wav');
        if (T == 0)
            disp('Transmission Started')
            disp(T)
        elseif(T == duration_signal) 
            disp('Transmission ends: see the final result')
            disp(T)
        else
            disp('Transmission in progress: please wait')
            disp(T)
        end

        t_start = 0;
        t_stop = 1;
        ts = 1/fs;
        t = t_start:ts:t_stop;

        message_t = data((fs*T+1):(fs*(T+1)+1));

        N = length(message_t);
        message_f = fftshift(abs(fft(message_t, N)/fs));
        freqaxis = linspace(-fs/2, fs/2, N);

        figure(1)
        hold all  % Keeps the previous plots and everytime changes the color

        subplot(2,1,1)
        plot(t + T, message_t)
        title('Time domain: Message signal')
        xlabel('time')
        ylabel('amplitude')
        grid on
        % First two are limits for x-axis, the other two are limits for y-axis: observe why 0 inf , and -5 5 are used here.
        hold on     % Keeps the previous plots 

        subplot(2,1,2)
        plot(freqaxis,message_f)
        title('Frequency domain: Message signal')
        xlabel('frequency (Hz)')
        ylabel('Magnitude')
        grid on
        hold on
        % axis([-10000 10000 -inf inf]) % First two are limits for x-axis, the other two are limits for y-axis: observe why -inf inf , and 0 3 are used here. 

        % pause(2)  % Pauses for 2 seconds and then go for next loop increment.
        % sound(data,fs)
    end
end