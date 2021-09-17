import numpy as np
import math
import matplotlib.pyplot as plt

A = 1
B = 10
t_start = -20
t_end = 20
fm = B
fs = 10*fm 
# fs>=2fm; fs=infinite (Nyquist Criteria)
ts = 1/fs

t = np.arange(t_start, t_end, ts)
sinc_pulse = 2*B*np.sinc(2*B*t)  # BP LATHI: mt= 2*B*sinc(2*B*pi*t);

plt.figure(1)
plt.plot(t, sinc_pulse)

# Give x axis label for the sinc plot
plt.xlabel('Time')
plt.ylabel('Amplitude')
plt.grid(True, which='both')
plt.axhline(y=0, color='m')


num_samples = fs * (t_end - t_start)

plt.figure(2)
frequency_axis = np.linspace(-fs/2, fs/2, S)
fourier_transform = np.fft.fft(sinc_pulse)
fourier_transform_processed_1 = np.abs(fourier_transform/num_samples)
fourier_transform_processed_2 = np.fft.fftshift(fourier_transform_processed_1)
plt.plot(frequency_axis, fourier_transform_processed_2, color="red")
plt.xlabel("Frequency(Hz)")
plt.ylabel("|M(f)|")
plt.title("Fourier Transform of the 2x{}xsinc(2pix{}xt) , B = {}".format(B, B, B))
plt.grid(color="black")
plt.show()
