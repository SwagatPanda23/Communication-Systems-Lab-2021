import numpy as np
import matplotlib.pyplot as plt
import math
from scipy import signal

signal_duration = 10

for T in range(signal_duration):

    # defining the common parameters

    N = 11  # Sum of last 2 digits of ID
    start_time = 0
    stop_time = 1
    f_carrier = 500
    fs = 10 * f_carrier
    ts = 1 / fs
    time = np.arange(start_time, stop_time, ts)
    A = 25
    # Because the min of the largest sinc pulse for this case is ~ -21,
    # hence for the envelope detector to work the carrier amplitude must be greater than this.

    carrier_signal_t = A * np.cos(2 * math.pi * f_carrier * time)
    carrier_signal_f = np.fft.fftshift(abs(np.fft.fft(carrier_signal_t) / fs))

    len_time = len(time)
    freq_axis = np.linspace(-fs / 2, fs / 2, len_time)

    # Defining the message signal
    B_max = 5
    B_min = 1
    B = np.random.randint(B_min, B_max + 1)
    message_t = 20 * B * np.sinc(20 * B * (time - (start_time + stop_time) / 2))
    message_f = np.fft.fftshift(abs(np.fft.fft(message_t) / fs))

    # Modulating the message signal
    message_mod_t = np.multiply((1 + message_t / A), carrier_signal_t)
    message_mod_f = np.fft.fftshift(abs(np.fft.fft(message_mod_t)) / fs)

    # Modelling noise
    mu = 0
    sigma_square = 10**(-6)
    sigma = np.sqrt(sigma_square)
    noise = mu + sigma * np.random.randn(len(message_t))

    # Modelling the Channel
    a = 0.01

    # Both of the following implementations work - uncomment any one at a time
    # 1. Implement the delta function
    channel_t1 = a*signal.unit_impulse(len(message_t), 'mid')
    channel_t = np.multiply(channel_t1, carrier_signal_t) / A

    output_t = np.convolve(message_mod_t, channel_t, mode='same') + noise
    output_f = np.fft.fftshift(abs(np.fft.fft(output_t) / fs))

    # 2. Instead of convolivng with the delta function,
    # directly multiply the output with the amplitude of channel_t,  for which I have used 'a' here.

    # output_t = a * message_mod_t
    # output_f = np.fft.fftshift(abs(np.fft.fft(output_t) / fs))

    # Demodulation - division by 2 to ensure that the amplitude of
    # the carrier which has been multiplied before is reduced to 1.

    # Subtraction of A * a to remove the DC value(which was modified by the channel)
    # we added for the envelope detector to work

    output_demod_t = abs(signal.hilbert(output_t)) - A * a
    output_demod_f = np.fft.fftshift(abs(np.fft.fft(output_demod_t) / fs))

    plt.figure(1)
    plt.subplots_adjust(top=0.959, bottom=0.068, left=0.065, right=0.978, hspace=0.925, wspace=0.2)
    plt.subplot(5, 1, 1)
    plt.plot(time + T, message_t)
    plt.title('Message signal time domain')
    plt.xlabel('time(t)')
    plt.ylabel('Amplitude')

    plt.subplot(5, 1, 2)
    plt.plot(time + T, carrier_signal_t)
    plt.title('Carrier signal time domain')
    plt.xlabel('time(t)')
    plt.ylabel('Amplitude')

    plt.subplot(5, 1, 3)
    plt.plot(time + T, message_mod_t)
    plt.title('Modulated signal time domain')
    plt.xlabel('time(t)')
    plt.ylabel('Amplitude')

    plt.subplot(5, 1, 4)
    plt.plot(time + T, output_t)
    plt.title('Modulated signal after the channel time domain')
    plt.xlabel('time(t)')
    plt.ylabel('Amplitude')

    plt.subplot(5, 1, 5)
    plt.plot(time + T, output_demod_t)
    plt.title('Demodulated signal time domain')
    plt.xlabel('time(t)')
    plt.ylabel('Amplitude')

    plt.figure(2)
    plt.subplots_adjust(top=0.959, bottom=0.068, left=0.065, right=0.978, hspace=0.925, wspace=0.2)
    plt.subplot(5, 1, 1)
    plt.plot(freq_axis, message_f)
    plt.title('Message signal frequency domain')
    plt.xlabel('Frequency (Hz)')
    plt.ylabel('Magnitude')
    plt.xlim([-2 * 20 * B_max, 2 * 20 * B_max])

    plt.subplot(5, 1, 2)
    plt.plot(freq_axis, carrier_signal_f)
    plt.title('Carrier signal frequency domain')
    plt.xlabel('Frequency (Hz)')
    plt.ylabel('Magnitude')
    plt.xlim([-2 * f_carrier, 2 * f_carrier])

    plt.subplot(5, 1, 3)
    plt.plot(freq_axis, message_mod_f)
    plt.title('Modulated signal frequency domain')
    plt.xlabel('Frequency (Hz)')
    plt.ylabel('Magnitude')
    plt.xlim([-2 * f_carrier, 2 * f_carrier])

    plt.subplot(5, 1, 4)
    plt.plot(freq_axis, output_f)
    plt.title('Modulated signal after the channel frequency domain')
    plt.xlabel('Frequency (Hz)')
    plt.ylabel('Magnitude')
    plt.xlim([-2 * f_carrier, 2 * f_carrier])

    plt.subplot(5, 1, 5)
    plt.plot(freq_axis, output_demod_f)
    plt.title('Demodulated signal frequency domain')
    plt.xlabel('Frequency (Hz)')
    plt.ylabel('Magnitude')
    plt.xlim([-2 * 20 * B_max, 2 * 20 * B_max])

plt.show()
