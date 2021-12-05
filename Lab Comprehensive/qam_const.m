close all
clear all
%%%%%%%%%%S M Zafaruddin%%%%%%%
%%%%%%%%EEE F311 Communication Systems%%%%%%%%%%%%%%%%%


%%%%%System parameters %%%%%%%%%%%%%
noise_power_watt= 2;%%%%%W/Hz

transmit_power_p_min= 100; %%%% in dBm. Sometimes given dBm/Hz
transmit_power_p_max= 1000; %%%% in dBm. Sometimes given dBm/Hz

for p= transmit_power_p_min:10:transmit_power_p_max  %%% this will increase the transmitted power of symbols.
  num_iter=10^2;
for iter=1:1:num_iter
    const=(1/sqrt(2)).*[1+1j, 1-1j, -1-1j, -1+1j ];
    m= const(randi(4));
    x= sqrt(p)*m;
    n= sqrt(noise_power_watt)*randn(1)+1j*sqrt(noise_power_watt)*randn(1);
    g=10^0.5;
    lambda=10;
    d=100;
   h=(g^2*lambda)/(4*pi*d); %%%channel coef.
      y= h*x+n;  %%%received signal
      
            
end 
figure(1)
hold all
scatter(real(x),imag(x))
hold on
scatter(real(y), imag(y))
grid on
end
