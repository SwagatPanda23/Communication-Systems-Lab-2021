A=2;
B=3;
t_start=-5;
t_end = 5;
fm = B;
fs = 10*fm; %%%fs>=2fm; fs=infinite (Nyquist Criteria)
ts = 1/fs;
mt_loop = [];
for t = t_start:ts:t_end
    mt = 2*B*sinc(2*B*t); %%%BP LATHI: mt= 2*B*sinc(2*B*pi*t);
    mt_loop = [mt_loop mt];
end
figure(1)
hold all
t_axis= t_start:ts:t_end;
subplot(2,1,1); stem(t_axis,mt_loop)
hold on
subplot(2,1,2); plot(t_axis,mt_loop)
xlabel('time')
ylabel('Amplitude')
keyboard