import numpy as np
import math
import matplotlib.pyplot as plt

Amplitude = 0.1
B = 10 # Frequency limit on one side of the pulse
t_start = -5
t_end = 5
fm = B
fs = 10*fm
ts = 1/fs

t = np.arange(t_start, t_end, ts)
sinc_pulse = Amplitude*2*B*np.sinc(2*B*t)  # BP LATHI: mt= 2*B*sinc(2*B*pi*t);

plt.figure(1)
plt.plot(t, sinc_pulse)
plt.xlabel('Time')
plt.ylabel('h(t)')
plt.title('Sinc Pulse: {}sinc({}t) , B = {}'.format(2*B, 2*math.pi*B, B))
plt.grid(True, which='both')
plt.axhline(y=0, color='m')


num_samples = fs*(t_end - t_start)


frequency_axis = np.linspace(-fs/2, fs/2, num_samples)
fourier_transform = np.fft.fft(sinc_pulse)
fourier_transform_processed_1 = np.abs(fourier_transform/fs)
fourier_transform_processed_2 = np.fft.fftshift(fourier_transform_processed_1)

plt.figure(2)
plt.plot(frequency_axis, fourier_transform_processed_2, color="red")
plt.xlabel("Frequency(Hz)")
plt.ylabel("|H(f)|")
plt.title("Fourier Transform of the {}sinc({}t) , B = {}".format(2*B, 2*math.pi*B, B))
plt.grid(True, which='both')

axes = plt.gca()
axes.set_xlim([-2*B, 2*B])
axes.set_ylim([None, None])


plt.show()
