clear;

fs = 10000;
ts = 1/fs;
start_time = 0;
stop_time = 1;
time = start_time:ts:stop_time;
N = length(time);
freq_axis = (linspace(-fs/2,fs/2, N));
raised_cosine_t = 200 * (cos(pi.*200.*(time - (-start_time + stop_time) ./ 2))./(1 - (2*200.*(time - (-start_time + stop_time) ./ 2)).^2)).*sinc(200.*(time - (-start_time + stop_time) ./ 2));
raised_cosine_f = abs(fftshift(fft(raised_cosine_t)/fs));
figure(1)
plot(time, raised_cosine_t)

figure(2)
plot(freq_axis, raised_cosine_f)