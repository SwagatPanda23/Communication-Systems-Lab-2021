
%% Generating Ringing Tone 
% - NOTE: THIS IS NOT A PART OF THE PROBLEM, IT WAS DONE TO GENERATE THE
% AUDIO FILE FOR FURTHER PARTS OF THE PROBLEM

% Ring Tone
fs = 10000;
T = 20;
t = 0:1/fs:T;

fr1 = 440;
fr2 = 480;

% noisy frequency - 1000 Hz
fr3 = 1000;

ring_tone_t = 0.1*sin(2*pi*fr1*t) + 0.1*sin(2*pi*fr2*t) + 0.1*sin(2*pi*fr3*t);
ring_tone_f = fftshift(abs(fft(ring_tone_t)/fs));

N = length(t);
freq = linspace(-fs/2, fs/2, N);

% Loop to set the Cadence for 2 seconds ON and then 4 seconds OFF 
for i = 1:1:T - 1
    if((mod(i,6) == 2)||(mod(i,6) == 3)||(mod(i,6) == 4)||(mod(i,6) == 5))
        ring_tone_t(1,i*fs:((i+1)*fs-1)) = 0;
    else 
        ring_tone_t(1,i*fs:((i+1)*fs-1)) = ring_tone_t(1,i*fs:((i+1)*fs-1));
    end
end

% sound(ring_tone,fs)

filename = 'ring_tone_noisy.wav';
audiowrite(filename,ring_tone_t, fs)

figure(1)
subplot(2,1,1)
plot(t, ring_tone_t)
title("Time Domain Plot - Noisy Ring Tone")
xlabel("Time(s)")
ylabel("Amplitude")
axis([0 0.5 -0.5 0.5]) 
grid on

subplot(2,1,2)
plot(freq, ring_tone_f)
title("Frequency Domain Plot - Noisy Ring Tone")
xlabel("Frequency (Hz)")
ylabel("Amplitude")
axis([-inf inf 0 2]) 
grid on

%% Filter Design for Ringing Tone
B = 600;
signal_t = ring_tone_t;
signal_f = fftshift(abs(fft(signal_t)/fs));
filter_t = 2*B*sinc(2*B*(t - T/2));
filter_f = fftshift(abs(fft(filter_t)/fs));

filtered_signal_t = conv(signal_t, filter_t, 'same')/fs;
filtered_signal_f = signal_f.*filter_f;

figure(2)
subplot(2,1,1)
plot(filter_t)
title("Time Domain Plot - Low Pass Filter")
xlabel("Time(s)")
ylabel("Amplitude")
axis([0 T*fs -inf inf]) 
grid on

subplot(2,1,2)
plot(freq, filter_f)
title("Frequency Domain Plot - Low Pass Filter")
xlabel("Frequency (Hz)")
ylabel("Amplitude")
grid on

figure(3)
subplot(2,1,1)
plot(t, filtered_signal_t)
title("Time Domain Plot - Filtered Ring Tone")
xlabel("Time(s)")
ylabel("Amplitude")
axis([0 0.5 -0.5 0.5])
grid on

subplot(2,1,2)
plot(freq, filtered_signal_f)
title("Frequency Domain Plot - Filtered Ring Tone")
xlabel("Frequency (Hz)")
ylabel("Amplitude")
axis([-inf inf 0 1]) 
grid on

% sound(filtered_signal_t,fs)

filename = 'ring_tone_filtered.wav';
audiowrite(filename,filtered_signal_t,fs)



