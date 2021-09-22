import numpy as np
from scipy.integrate import quad
import matplotlib.pyplot as plt
import math
from sympy import *


def gauss_integral(mu, sigma):
    PDF = lambda x: np.exp(-(x - mu)**2/(2*sigma**2))/(sigma*math.sqrt(2*pi))
    total_prob, error_prob = quad(lambda x: np.exp(-(x - mu)**2/(2*sigma**2))/(sigma*math.sqrt(2*pi)), -np.inf, np.inf)
    mean, error_m = quad(lambda x: x*np.exp(-(x - mu)**2/(2*sigma**2))/(sigma*math.sqrt(2*pi)), -np.inf, np.inf)
    expectation_xsq_fx, error_var = quad(lambda x: x**2*np.exp(-(x - mu)**2/(2*sigma**2))/(sigma*math.sqrt(2*pi)), -np.inf, np.inf)

    variance = expectation_xsq_fx - mean**2
    return [PDF, total_prob, mean, variance]


mu = 1
sigma = 1
xmin = -4
xmax = 6
fs = 10

x_plot = np.arange(xmin, xmax, 1/fs)
PDF, total_probability, mean, variance = gauss_integral(mu, sigma)
print('Total Probability of the PDF', total_probability,
      '\nMean of the PDF', mean,
      '\nVariance of the PDF', variance)

plt.figure(1)
plt.plot(x_plot, PDF(x_plot))
plt.title('Gaussian PDF')
plt.xlabel('Running Variable')
plt.ylabel('Amplitude')
plt.show()

# Additional -- Finding PDF using symbolic integration
x = Symbol('x')
PDF = exp(-(x - mu)**2/(2*sigma**2))/(sigma*sqrt(2*pi))
CDF = integrate(PDF, x)
print('The CDF is', CDF)

