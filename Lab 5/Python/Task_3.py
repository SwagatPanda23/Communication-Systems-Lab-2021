import numpy as np
from scipy import signal
import matplotlib.pyplot as plt
import math


time_endpt = 30
for T in range(time_endpt):

    # Defining all the common parameters for each second
    start_time = 0
    stop_time = 1
    B = 2
    fs = 10*B
    ts = 1/fs
    time = np.arange(start_time, stop_time, ts)

    # Generating the message signal
    message_t = 2 * B * np.sinc(2 * math.pi * B * (time - (-start_time + stop_time)/2))

    # Modelling the Channel
    a = 0.5  # a is less than 1

    channel_t = signal.unit_impulse(len(message_t), 'mid')

    plt.figure(1)
    plt.plot(time + T, message_t)
    plt.title('Message - Time Domain')
    plt.xlabel('Time')
    plt.ylabel('Amplitude')

    # Modelling noise
    mu = 0  # Sum of last two digits of ID
    sigma_square = 5  # Sum of last three digits of ID
    sigma = math.sqrt(sigma_square)

    noise = mu + sigma * np.random.randn(len(message_t))

    # If channel method is used.
    # Modify the amplitude of the noise signal and see the effect
    output_t = np.convolve(message_t, channel_t, mode='same')/fs + 0.01*noise
    
    # If we convolve the output directly
    # Modify the amplitude of the noise signal and see the effect
    # output_t = a*message_t+ 0*noise

    plt.figure(2)
    plt.plot(time + T, output_t)
    plt.title('Output - Time Domain')
    plt.xlabel('Time')
    plt.ylabel('Amplitude')

    # plt.pause(1)

plt.show()
