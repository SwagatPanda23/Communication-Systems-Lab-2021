import numpy as np
from scipy.integrate import quad
import matplotlib.pyplot as plt
from sympy import *


def uniform_integral(a, b):
    PDF = lambda x: x**0 * 1 / (b - a)
    total_prob, error_prob = quad(lambda x: x**0 * 1 / (b - a), a, b)
    mean, error_m = quad(lambda x: x**1 * 1 / (b - a), a, b)
    expectation_xsq_fx, error_var = quad(lambda x: x**2 * 1 / (b - a), a, b)

    variance = expectation_xsq_fx - mean**2
    return [PDF, total_prob, mean, variance]


a = 1
b = 4
fs = 100

x_plot = np.arange(a, b, 1/fs)

PDF, total_probability, mean, variance = uniform_integral(a, b)
print('Total Probability of the PDF', total_probability,
      '\nMean of the PDF', mean,
      '\nVariance of the PDF', variance)

plt.figure(1)
plt.plot(x_plot, PDF(x_plot))
plt.title('Uniform PDF')
plt.xlabel('Running Variable')
plt.ylabel('Amplitude')
plt.show()

# Additional -- Finding PDF using symbolic integration
x = Symbol('x')
PDF = x**0 * 1 / (b - a)
CDF = integrate(PDF, x)
print('The CDF is', CDF)

