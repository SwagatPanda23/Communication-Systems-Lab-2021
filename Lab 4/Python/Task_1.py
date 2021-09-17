import numpy as np
import matplotlib.pyplot as plt
import random
import math

time_endpt = 30
for T in range(time_endpt):

    # Defining all the common parameters for each second
    start_time = 0
    stop_time = 1
    fm = 3    # Maximum frequency component in Hertz for the given spectrum - Last digit of ID number goes here
    fs = 10*fm
    ts = 1/fs
    time = np.arange(start_time, stop_time, ts)

    # Generating the message signal
    U = random.randint(1, 5)
    message_t = U*np.cos(2*math.pi*fm*time)    
    message_f = np.fft.fftshift(abs(np.fft.fft(message_t)/fs))

    # Frequency axis
    N = len(message_f)
    freq_axis = np.linspace(-fs/2, fs/2, N)  

    plt.figure(1)
    plt.plot(time + T, message_t)
    plt.title('Time Domain')
    plt.xlabel('Time')
    plt.ylabel('Amplitude')

    plt.figure(2)
    plt.plot(freq_axis, message_f)
    plt.title('Frequency Domain')
    plt.xlabel('Frequency')
    plt.ylabel('Amplitude')

    # plt.pause(1)

plt.show()
