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

figure(1)
hold all
subplot(2,1,1); 
plot(time,channel_t)
title('Time domain: Channel characteristics')
xlabel('time')
ylabel('Amplitude')
hold on
subplot(2,1,2);
plot(freq,fftshift((channel_f)),'red')
title('Frequency domain: Channel characteristics')
xlabel('frequency')
ylabel('Amplitude')
