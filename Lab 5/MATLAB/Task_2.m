clear

mu = 11;    % Sum of last two digits of ID
sigma_square = 20;     % Sum of last three digits of ID
sigma = sqrt(sigma_square);

num_samples = 10^6;
num_bins = 25;

PDF = mu + sigma.*randn(num_samples,1);

figure(1)
histogram(PDF, num_bins)
title('Gaussian PDF Histogram')
xlabel('Running Variable')
ylabel('Amplitude')

% Q function using the predefined function as well as by counting the number of elements using a loop
count_for = 0;
Qfunc_special = qfunc(1);

for i=1:num_samples
    if PDF(i) > mu + sigma
        count_for = count_for + 1;
    end
end
Qfunc_forloop = count_for/num_samples;
disp('The value of Q function using qfunc() is:')
disp(Qfunc_special)
disp('And the value of Q function by counting individual values is:') 
disp(Qfunc_forloop)

% Auto-correlation function
tau = 10;

figure(2)
[correlate, lags] = xcorr(PDF, PDF);
plot(lags,correlate)
title('Autocorrelation Function of Gaussian RV')
xlabel('Lag')
ylabel('Autocorrelation')

% Power Spectral Density 
% Reference - https://www.mathworks.com/help/signal/ug/power-spectral-density-estimates-using-fft.html
figure(3)
N = length(PDF);
xdft = fft(PDF);
psdx = (1/(2*pi*N)) * abs(xdft).^2;
freq = 0:(2*pi)/N:2*pi-(2*pi)/N;

plot(freq/pi,10*log10(psdx))
grid on
title('Periodogram Using FFT')
xlabel('Normalized Frequency (\times\pi rad/sample)') 
ylabel('Power/Frequency (dB/rad/sample)')

