import numpy as np
from scipy.integrate import quad
import matplotlib.pyplot as plt
from sympy import *


def exp_integral(k):
    PDF = lambda x: k * np.exp(-k * x)
    total_prob, error_prob = quad(lambda x: k * np.exp(-k * x), 0, np.inf)
    mean, error_m = quad(lambda x: k * x * np.exp(-k * x), 0, np.inf)
    expectation_xsq_fx, error_var = quad(lambda x: k * x**2 * np.exp(-k * x), 0, np.inf)

    variance = expectation_xsq_fx - mean**2
    return [PDF, total_prob, mean, variance]


parameter = 5
xmin = 0
xmax = 5
fs = 10

x_plot = np.arange(xmin, xmax, 1/fs)
PDF, total_probability, mean, variance = exp_integral(parameter)
print('Total Probability of the PDF', total_probability,
      '\nMean of the PDF', mean,
      '\nVariance of the PDF', variance)

plt.figure(1)
plt.plot(x_plot, PDF(x_plot))
plt.title('Exponential PDF')
plt.xlabel('Running Variable')
plt.ylabel('Amplitude')
plt.show()

# Additional -- Finding PDF using symbolic integration
x = Symbol('x')
PDF = parameter*exp(-parameter*x)
CDF = integrate(PDF, x)
print('The CDF is', CDF)

