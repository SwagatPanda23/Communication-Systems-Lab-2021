import numpy as np
from scipy.integrate import quad
import matplotlib.pyplot as plt
from sympy import *


def rayleigh_integral(sigma):
    PDF = lambda x: x*np.exp(-x**2/(2*sigma**2))/(sigma**2)
    total_prob, error_prob = quad(lambda x: x*np.exp(-x**2/(2*sigma**2))/(sigma**2), 0, np.inf)
    mean, error_m = quad(lambda x: x**2*np.exp(-x**2/(2*sigma**2))/(sigma**2), 0, np.inf)
    expectation_xsq_fx, error_var = quad(lambda x: x**3*np.exp(-x**2/(2*sigma**2))/(sigma**2), 0, np.inf)

    variance = expectation_xsq_fx - mean**2
    return [PDF, total_prob, mean, variance]


sigma = 1
xmin = 0
xmax = 5
fs = 10

x_plot = np.arange(xmin, xmax, 1/fs)
PDF, total_probability, mean, variance = rayleigh_integral(sigma)
print('Total Probability of the PDF', total_probability,
      '\nMean of the PDF', mean,
      '\nVariance of the PDF', variance)

plt.figure(1)
plt.plot(x_plot, PDF(x_plot))
plt.title('Rayleigh PDF')
plt.xlabel('Running Variable')
plt.ylabel('Amplitude')
plt.show()

# Additional -- Finding PDF using symbolic integration
x = Symbol('x')
PDF = x*exp(-x**2/(2*sigma**2))/(sigma**2)
CDF = integrate(PDF, x)
print('The CDF is', CDF)

