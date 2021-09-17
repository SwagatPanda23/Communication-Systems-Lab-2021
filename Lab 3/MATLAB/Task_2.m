% Channel modelling
Amplitude = 0.01;
B = 10;
t_start = -10;
t_end = 10;
fm = B;
fs = 10*fm; %%%fs>=2fm; fs=infinite
ts = 1/fs;
mt_loop = [];
time = t_start:ts:t_end;

channel_t = Amplitude*2*B*sinc(2*B*time); %%% m_t= 2*B*sin(2*B*pi*t)
N = length(channel_t);
channel_f = abs(fft(channel_t,N)/fs);
freq = linspace(-fs/2, fs/2, N);

% Signal modelling and its FFT
message_t = sin(10*pi*time) + sin(40*pi*time);
message_f = abs(fft(message_t, length(message_t))/fs);

% Convolution
output_t = conv(message_t, channel_t, 'same');


% Multiply in frequency domain
output_f = message_f.*channel_f;


figure(1)
hold all
subplot(2,2,1);
plot(time,message_t)
title('Time domain: Message')
xlabel('time')
ylabel('Amplitude')
xlim([-1 1])

subplot(2,2,2)
plot(time,output_t)
title('Time domain: Output')
xlabel('time')
ylabel('Amplitude')
xlim([-1 1])

hold on
subplot(2,2,3);
plot(freq,fftshift(message_f),'red')
title('Frequency domain: Message')
xlabel('frequency')
ylabel('Amplitude')

subplot(2,2,4)
plot(freq,fftshift(output_f),'red')
title('Frequency domain: Output')
xlabel('frequency')
ylabel('Amplitude')



