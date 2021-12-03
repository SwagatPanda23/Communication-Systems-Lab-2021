clc;
clear;
close all;
 
% Message Signal
N = 100; 
data = randi([0 1],N,1); 
data = reshape(data,1,length(data)); 
 
data_polar = 2*data-1; 
bit_rate = 10.^6;
Tb = 1/bit_rate ; 
t = 0:Tb/100:Tb ; 
 
% BPSK
M = 2;
x_const = [];

% Constellation Points
P = 10^-22;
C = [];  

% Signal Detection
P_end = 1;
bit_error_rate = [];
signal_power_dB = [];
ber_qfunc = [];

% Message Signal and BPSK transmission using Constellation
for m = 0:M - 1
    C = [C exp(-1i*m*2*pi/M)];
end
 
for n = 1:length(data) 
    if data_polar(1,n) == -1  
        xc = C(2);
    elseif data_polar(1,n) == 1  
        xc = C(1);
    end
    x_const = [x_const xc];
end
 
% AWGN
noise_db = -150;
bandwidth = 100;
noise_power = (10^((noise_db/10)-3))*bandwidth;
noise_Variance = noise_power/(length(x_const(:))-1);
noise_Std_Dev = sqrt(noise_Variance);
noise = noise_Std_Dev*randn(size(x_const));
 
while P<= P_end
    Tx_const = sqrt(P)*x_const; 
    Rx_const = Tx_const + noise;
 
    Received_Sig = [];
    for i = 1:N
        if real(Rx_const(i))>=0
            Received_Sig = [Received_Sig 1];
        else 
            Received_Sig = [Received_Sig 0];
        end 
    end
 
    [~,ratio] = biterr(Received_Sig, data);
    bit_error_rate = [bit_error_rate ratio];
    signal_power_dB = [signal_power_dB 10*log10(P)];
    snr = P/noise_power;
    ber_qfunc = [ber_qfunc qfunc(sqrt(snr))];
    P = P*10;
end
 
% display the signal with Power = P_end
scatterplot(Tx_const,[],[],'b*');
title('Transmitted Signal Power');
scatterplot(Rx_const,[],[],'r*');
title('Received Signal Power');
 
figure(3)
plot(signal_power_dB,bit_error_rate)
hold on
plot(signal_power_dB,ber_qfunc) 
ylim([0 0.6]);
legend('Average BER','Theoretical BER')
xlabel('Signal Power in dB')
ylabel('BER Ratio')
title('BER Vs Signal Power');