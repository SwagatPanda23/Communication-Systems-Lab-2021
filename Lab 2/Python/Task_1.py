import numpy as np
import math
import matplotlib.pyplot as plt

A = 1
B = 10
t_start = -5
t_end = 5
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
plt.show()