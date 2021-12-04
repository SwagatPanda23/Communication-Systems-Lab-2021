import sys
import numpy as np
import matplotlib.pyplot as plt
from scipy import integrate
from scipy import signal

############### QUE 3a ###############
# Recall that the fourier series of square wave.

# Preliminary variables.
Fm = 5 # 10Hz
n_harm = 1000 # No. of harmonics to add. The more the merrier.
A = 2
T_START = 0
T_END = 1
Fs = 1000
t = np.linspace(T_START, T_END, int((T_END - T_START)*Fs))

# creating the square wave.
count = 0
sq_wave = np.zeros_like(t)
while count < n_harm:
    h = 2*count + 1
    sq_wave = sq_wave + (A/h)*np.sin(2*np.pi*h*Fm*t)
    count = count + 1

# Plotting the result Q3a.
f1 = plt.figure(1)
plt.plot(t, sq_wave, color='black', linestyle='-', linewidth=1.5)
plt.ylabel('Amplitude (V)')
plt.xlabel('Time (sec)')
plt.title("Square wave from sines")
plt.grid(True, which="both")
plt.axhline(y=0, color='r')
f1.suptitle("QUE 3a", fontsize=16)

############### QUE 3b ###############
# This question requires integration of the PDF. We will use the 
# scipy.integrate module as discussed in the lab sessions. For the sake
# of clarity, I won't define the integrand as a lambda function.

def fx_pdf(x):
    return (1/4)*np.exp(-np.abs((x - 2))/2)

# scipy's quad is derived from Fortran's QUADPACK:
# https://en.wikipedia.org/wiki/QUADPACK
# A majority of QUADPACK's routines are Gauss Quadrature (Adaptive/Non-
# Adaptive) based.

I = integrate.quad(fx_pdf, -np.inf, 1)

print("P(X <= 1) = {0}, Absolute Error Estimate = {1} \n".format(I[0], I[1]))

############### QUE 3c ###############
# Preliminary Parameters
T_START = 0
T_END = 2
Fs = 1000
NU = 0
SIGMA = 6

t = np.linspace(T_START, T_END, int((T_END - T_START)*Fs))

awgn_t = np.random.normal(NU, SIGMA, len(t))

# To get a smooth result. You need a large number of gaussian samples.
# To test that, increase Fs to a very large value. Try changing Fs to
# 0.5e6 and T_END to 2 sec for 1M samples.
# Calculating ACF
acf_t = signal.correlate(awgn_t, awgn_t, mode='full')
acf_t = np.append(acf_t, 0)
t_new = np.linspace(T_START - T_END, T_START + T_END, len(acf_t))

# Calculating PSD
psd_f = np.fft.fft(acf_t)
psd_f = np.fft.fftshift(psd_f)
psd_f = np.abs(psd_f)
f_axis = np.linspace(-Fs/2, Fs/2, len(psd_f))


# For the sake of learning -> Merging two subplots in matplotlib:
# https://matplotlib.org/stable/gallery/subplots_axes_and_figures/gridspec_and_subplots.html
# https://matplotlib.org/stable/tutorials/intermediate/gridspec.html

f3 = plt.figure()
gs = f3.add_gridspec(2,2)
f3_ax1 = f3.add_subplot(gs[0,:])
f3_ax2 = f3.add_subplot(gs[1,0])
f3_ax3 = f3.add_subplot(gs[1,1])

f3_ax1.plot(t, awgn_t, color='black', linestyle='-', linewidth=1, label='AWGN')
f3_ax1.set_title("Gaussian Random Process")
f3_ax1.axhline(y=0, color='r')
f3_ax1.grid(True, which='major', color='0.50')
f3_ax1.grid(True, which='minor', color='0.80', linestyle='--')
f3_ax1.minorticks_on()
f3_ax1.set_xlabel('Time (sec)')
f3_ax1.set_ylabel('Amplitude (V)')

f3_ax2.plot(t_new, acf_t, color='blue', linestyle='-', linewidth=1, label='ACF')
f3_ax2.set_title("ACF of Gaussian Process")
f3_ax2.axhline(y=0, color='r')
f3_ax2.grid(True, which='major', color='0.50')
f3_ax2.grid(True, which='minor', color='0.80', linestyle='--')
f3_ax2.minorticks_on()
f3_ax2.set_xlabel('Time (sec)')
f3_ax2.set_ylabel('Rx(t)')

f3_ax3.plot(f_axis, psd_f, color='brown', linestyle='-', linewidth=1, label='ACF')
f3_ax3.set_title("PSD of Gaussian Process")
f3_ax3.axhline(y=0, color='r')
f3_ax3.grid(True, which='major', color='0.50')
f3_ax3.grid(True, which='minor', color='0.80', linestyle='--')
f3_ax3.minorticks_on()
f3_ax3.set_xlabel('Frequency (Hz)')
f3_ax3.set_ylabel('PSD')

f3.suptitle("QUE 3c", fontsize=16)
f3.tight_layout()

plt.show()