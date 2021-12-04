close all;
%% Preliminary Variables
NUM_SAMPLES = 100;
BITRATE = 100; % Bits per sec
Tb = 1/BITRATE; % Time Per Bit
RES = 200; % Samples per bit.
Fs = RES*BITRATE; % Samples per sec, i.e. sampling freq

%% Generating the random signal and extracting the line codes
% Refer to the MATLAB functions in the parent directory for the line code
% functions used. The amplitude is 1/0/-1 in all pulses.
% Generate Random Bitstream.
sig = randi([0, 1], 1, NUM_SAMPLES);

% Getting Line-Codes and one pulse for each line code.
[t_unrz, X_unrz] = unrz(sig, BITRATE, RES); % ON-OFF NRZ
[t_unrz_p, p_unrz] = unrz(1, BITRATE, RES); % p(t) for ON-OFF NRZ
[t_pnrz, X_pnrz] = pnrz(sig, BITRATE, RES); % Polar NRZ
[t_pnrz_p, p_pnrz] = pnrz(1, BITRATE, RES); % p(t) for Polar NRZ
[t_urz, X_urz] = urz(sig, BITRATE, RES); % ON-OFF RZ
[t_urz_p, p_urz] = urz(1, BITRATE, RES); % p(t) for ON-OFF RZ
[t_prz, X_prz] = prz(sig, BITRATE, RES); % Polar RZ
[t_prz_p, p_prz] = prz(1, BITRATE, RES); % p(t) for Polar RZ

% Get the fourier transform of each p(t) <=> P(f)
[P_unrz, f_unrz] = perform_fft(p_unrz, Fs);
[P_pnrz, f_pnrz] = perform_fft(p_pnrz, Fs);
[P_urz, f_urz] = perform_fft(p_urz, Fs);
[P_prz, f_prz] = perform_fft(p_prz, Fs);

% Get the amplitude arrays of each line code for a_k.
% ON-OFF NRZ
a_unrz = sig; % ON-OFF NRZ's a_k is the signal itself with amplitude = 1.
% Polar NRZ
a_pnrz = sig;
msk = (a_pnrz == 0);
a_pnrz(msk) = -1;
% ON-OFF RZ
a_urz = a_unrz;
% Polar RZ
a_prz = a_pnrz;
%% Getting the Rn from Autocorrelation
% For this, we want the acf for all possible lags. So use the function
% xcorr with the lags parameter. It is clear that, since the product
% uses a_k * a_(k + n). It will be zero for n < -NUM_SAMPLES and
% n > NUM_SAMPLES. Verify that the lags vector contains the values within
% this exact range.
[r_unrz, lags_unrz] = xcorr(a_unrz, a_unrz);
[r_pnrz, lags_pnrz] = xcorr(a_pnrz, a_pnrz);
[r_urz, lags_urz] = xcorr(a_urz, a_urz);
[r_prz, lags_prz] = xcorr(a_prz, a_prz);

% The sum of Rn in Sx(f) is from n = 1 to inf. 
% NRZ
R0_unrz = r_unrz(lags_unrz == 0);
Rn_sum_unrz = sum(r_unrz(lags_unrz > 0)); % from n = 1 to inf
R0_pnrz = r_pnrz(lags_pnrz == 0);
Rn_sum_pnrz = sum(r_pnrz(lags_pnrz > 0)); % from n = 1 to inf
% RZ
R0_urz = r_urz(lags_urz == 0);
Rn_sum_urz = sum(r_urz(lags_urz > 0)); % from n = 1 to inf
R0_prz = r_prz(lags_prz == 0);
Rn_sum_prz = sum(r_prz(lags_prz > 0)); % from n = 1 to inf

% Generating the Sx(f) terms.
Sx_unrz = (1/Tb)*(R0_unrz + 2*Rn_sum_unrz*cos(2*pi*f_unrz*Tb));
Sx_pnrz = (1/Tb)*(R0_pnrz + 2*Rn_sum_pnrz*cos(2*pi*f_pnrz*Tb));
Sx_urz = (1/Tb)*(R0_urz + 2*Rn_sum_urz*cos(2*pi*f_urz*Tb));
Sx_prz = (1/Tb)*(R0_prz + 2*Rn_sum_prz*cos(2*pi*f_prz*Tb));

%% Getting the final PSD from the formulae and plotting the results.
Sy_unrz = (abs(P_unrz).^2).*Sx_unrz;
Sy_pnrz = (abs(P_pnrz).^2).*Sx_pnrz;
Sy_urz = (abs(P_urz).^2).*Sx_urz;
Sy_prz = (abs(P_prz).^2).*Sx_prz;

figure(1)
plot(f_unrz, Sy_unrz, 'LineStyle','-', 'LineWidth',1,'Color','k')
hold on
plot(f_pnrz, Sy_pnrz, 'LineStyle','-', 'LineWidth',1,'Color','r')
hold on
plot(f_urz, Sy_urz, 'LineStyle','--', 'LineWidth',1,'Color','g')
hold on
plot(f_prz, Sy_prz, 'LineStyle','--', 'LineWidth',1,'Color','b')
hold off
title("PSD Specturm using the formula")
legend("UNRZ", "PNRZ", "URZ", "PRZ")

%% Let's verify the results using periodogram()
% https://in.mathworks.com/help/signal/ref/periodogram.html
% The output of periodogram wasn't centered, therefore, this section didn't
% work as expected. However, verify the sinc pulse nature of ON-OFF RZ from
% the plot.

% [psd_unrz, f_psd_unrz] = periodogram(X_unrz, [], length(X_unrz), Fs);
% [psd_pnrz, f_psd_pnrz] = periodogram(X_pnrz, [], length(X_pnrz), Fs);
% [psd_urz, f_psd_urz] = periodogram(X_urz, [], length(X_urz), Fs);
% [psd_prz, f_psd_prz] = periodogram(X_prz, [], length(X_prz), Fs);
% 
% figure(2)
% plot(f_psd_unrz, psd_unrz, 'LineStyle','-', 'LineWidth',1,'Color','k')
% hold on
% plot(f_psd_pnrz, psd_pnrz, 'LineStyle','-', 'LineWidth',1,'Color','r')
% hold on
% plot(f_psd_urz, psd_urz, 'LineStyle','--', 'LineWidth',1,'Color','g')
% hold on
% plot(f_psd_prz, psd_prz, 'LineStyle','--', 'LineWidth',1,'Color','b')
% hold off
% legend("UNRZ", "PNRZ", "URZ", "PRZ")
% title("PSD Specturm using periodogram")
