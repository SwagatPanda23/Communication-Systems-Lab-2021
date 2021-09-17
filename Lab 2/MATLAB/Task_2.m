% Wireline Channel modelling - 0.40 mm wire

R_oc = 280;
a_c = 0.0969;
L_0 = 587.3*10^(-6);
L_inf = 426*10^(-6);
b = 1.385;
f_m = 745900;
C_inf = 50*10^(-9);
C_0 = 0*10^(-9);
c_e = 1;
g_0 = 0;
g_e = 1;

% Part 1
freq = [4, 4000, 4000000 ]*10^3;

for f = 1:3
    R1 = (R_oc^4 + a_c*(freq(f))^2)^(1/4);
    L1 = (L_0 + L_inf*(freq(f)/f_m)^b)/(1 + (freq(f)/f_m)^b);
    G1 = g_0*freq(f)^(g_e);
    C1 = C_inf + C_0*freq(f)^(- c_e);

    omega1 = 2*pi*freq(f);
    gamma1 = sqrt((R1 + 1i*L1*omega1)*(G1 + 1i*C1*omega1));
    for i = 1:1:10
        d1(i) = 10 + (i-1)*500;
        H1(i) = 10*log10(abs(exp(- gamma1*d1(i)/1000)));
    end
    
    subplot(2,2,f)
    plot(d1,H1)
    str = sprintf('Relation of H(f) with Distance at a fixed frequency of %d Hz', freq(f));
    title(str)
    xlabel('Distance(in metres)')
    ylabel('H(f)(in dB)')

end


