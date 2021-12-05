clear all 
B=1;
Ts=1/2; %%%for (a) Ts=1; for (b) Ts=1/4; for (c) Ts=1/2 optimal
fs=10;
ts=1/fs;
t=-10:ts:10;
xt= 2*sinc(2*t);
ht=2*sinc(2*t);
yt=conv(xt,ht,'same');
figure(1)
hold all
plot(t, yt)

fs=10;
ts=1/fs;
t=-10:ts:10;
xt= -2*sinc(2*t-Ts);
ht=2*sinc(2*B*t);
yt=conv(xt,ht,'same');
figure(1)
hold all
plot(t, yt)


fs=10;
ts=1/fs;
t=-10:ts:10;
xt= 2*sinc(2*t-2*Ts);
ht=2*sinc(2*t);
yt=conv(xt,ht,'same');
figure(1)
hold all
plot(t, yt)