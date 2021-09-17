% Ring Tone

fs2 = 10000;
T2 = 23;
t2 = 0:1/fs2:T2;

fr1 = 440;
fr2 = 480;

ring_tone = 0.1*sin(2*pi*fr1*t2) + 0.1*sin(2*pi*fr2*t2);


% Loop to set the Cadence for 2 seconds ON and then 4 seconds OFF 
for i = 1:1:T2
    if((mod(i,6) == 2)||(mod(i,6) == 3)||(mod(i,6) == 4)||(mod(i,6) == 5))
        ring_tone(1,i*fs2:((i+1)*fs2-1)) = 0;
    else 
        ring_tone(1,i*fs2:((i+1)*fs2-1)) = ring_tone(1,i*fs2:((i+1)*fs2-1));
    end
end

sound(ring_tone,fs2)

filename = 'ring_tone_983.wav';
audiowrite(filename,ring_tone,fs2)

ring_tone = ring_tone(1,1:numel(t2));
figure(1)
plot(t2,ring_tone)
title("Time Domain Plot - Busy Tone")
xlabel("Time(s)")
ylabel("Amplitude")
axis([0 10 -0.3 0.3]) 
