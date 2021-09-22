import numpy as np
from scipy import special
import matplotlib.pyplot as plt
import math


mu = 11    # Sum of last two digits of ID
sigma_square = 20     # Sum of last three digits of ID
sigma = math.sqrt(sigma_square)
# tmin = 0
# xmax = 6
# time = np.arange(tmin, tmax, fs)
num_samples = 10**4
num_bins = 25

PDF = mu + sigma*np.random.randn(num_samples)
# The following can also be used.
# PDF = np.random.normal(mu, sigma, num_samples)

# x_plot = np.arange(xmin, xmax, num_samples)

plt.figure(1)
plt.hist(PDF, histtype='stepfilled', bins=num_bins)
plt.title('Gaussian PDF Histogram')
plt.xlabel('Running Variable')
plt.ylabel('Amplitude')

# Q function using scipy.special as well as by counting the number of elements using a loop
count_for = 0
Qfunc_special = 0.5*(1 - special.erf(1/math.sqrt(2)))

for i in range(num_samples):
    if PDF[i] > mu + sigma:
        count_for = count_for + 1

Qfunc_forloop = count_for/num_samples
print('The value of Q function using special.erf() is:', Qfunc_special,
      'And the value of Q function by counting individual values is:', Qfunc_forloop)

# Auto-correlation function
tau = 10**3

plt.figure(2)
acorr_pdf = plt.acorr(PDF, maxlags=tau)
plt.title('Autocorrelation Function of Gaussian RV using plt.acorr')
plt.xlabel('Lag')
plt.ylabel('Autocorrelation')

# Alternate approach for autocorrelation function
acorr_pdf_2 = np.correlate(PDF, PDF, mode = 'full')
plt.figure(3)
plt.plot(acorr_pdf_2)
plt.title('Autocorrelation Function of Gaussian RV using np.correlate')
plt.xlabel('Lag')
plt.ylabel('Autocorrelation')

# Power Spectral Density
fs = 1000
plt.figure(4)
plt.psd(PDF, fs)
plt.title('PSD using plt.psd()')
plt.show()