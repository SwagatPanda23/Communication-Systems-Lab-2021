close all
clear all
%%%%%%%%%%S M Zafaruddin%%%%%%%
%%%%%%%%EEE F311 Communication Systems%%%%%%%%%%%%%%%%%


%%%%%System parameters %%%%%%%%%%%%%
noise_power_watt= 2;

transmit_power_p_min= 100;
transmit_power_p_max= 1000; 

simulation_avg= [];
theoretical_direct_formula= [];
for p= transmit_power_p_min:10:transmit_power_p_max  %%% this will increase the transmitted power of symbols.
   symbol_err=0;  %%%%%%%initialization
num_iter=10^5;
for iter=1:1:num_iter
    const=[1 -1];
    m= const(randi(2));
    x= sqrt(p)*m;
    n= sqrt(noise_power_watt)*randn(1);
    g=10^0.5;
    lambda=10;
    d=100;
   h=(g^2*lambda)/(4*pi*d); %%%channel coef.
    y= h*x+n;  %%%received signal
    x_est=y/(h*sqrt(p));
    threshold= (const(1)+const(2))/2;  %%%threshold or decision boundary
    if (m==const(1)) && (x_est<threshold)  %%%%condition for error
        symbol_err=symbol_err+1;
    end
            if (m==const(2)) && (x_est>threshold)  %%%condition for error
                symbol_err=symbol_err+1;
            end
  
end 
simulation_avg= [simulation_avg symbol_err/num_iter];
received_snr=(abs(h)^2*p)/noise_power_watt;
theoretical_direct_formula= [theoretical_direct_formula qfunc(sqrt(received_snr))];

end
p_axis= transmit_power_p_min:10:transmit_power_p_max ;

figure(1);
plot(p_axis, simulation_avg)
hold on
grid on
plot(p_axis, theoretical_direct_formula)
legend('Simulation (Avg value)', 'Theoretical (Direct Formula)', 'location','Best')

grid on 

xlabel('P')
ylabel('BER')
keyboard
