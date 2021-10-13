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
    f_carrier = 100
    fs = 10 * f_carrier
    ts = 1 / fs
    time = np.arange(start_time, stop_time, ts)
    A = 2
    carrier_signal_t = A * np.cos(2 * math.pi * f_carrier * time)
    carrier_signal_f = np.fft.fftshift(abs(np.fft.fft(carrier_signal_t) / fs))

    len_time = len(time)
    freq_axis = np.linspace(-fs / 2, fs / 2, len_time)

    # Defining the message signal
    Am = np.random.randint(1, 11)
    message_t = Am * np.cos(2 * math.pi * N * time)
    message_f = np.fft.fftshift(abs(np.fft.fft(message_t) / fs))

    # Modulating the message signal
    # Single Sideband Signal - the following is for USSB generation.
    # If the - sign is replaced with a + sign, we get the LSSB signal.
    message_mod_ssb_t = np.multiply(message_t, np.cos(2 * math.pi * f_carrier * time)) - \
                        np.imag(signal.hilbert(message_t) * np.sin(2 * math.pi * f_carrier * time))
    message_mod_ssb_f = np.fft.fftshift(abs(np.fft.fft(message_mod_ssb_t)) / fs)

    # FOR LAB 7, THE PART THAT FOLLOWS IS NOT IN THE PROBLEM, IT WAS DONE FOR CONTINUATION TO THE PREVIOUS
    # LABS WHICH HAD DEMODULATION.

    # Modelling noise
    mu = 0
    sigma_square = 10 ** (-4)
    sigma = np.sqrt(sigma_square)
    noise = mu + sigma * np.random.randn(len(message_t))

    # Modelling the Channel - Multiplied with carrier to shift it to the carrier frequency.
    B = 4 * N
    channel_t = np.multiply(2 * B * np.sinc(2 * B * (time - (start_time + stop_time) / 2)), carrier_signal_t)
    output_t = np.convolve(message_mod_ssb_t, channel_t, mode='same') / fs + noise
    output_f = np.fft.fftshift(abs(np.fft.fft(output_t) / fs))

    # Demodulation - division by 2 to ensure that
    # the amplitude of the carrier which has been multiplied before is reduced to 1.

    # I did not use Hilbert based envelope detector demodulation for SSB
    # because it is very inefficient -- https://www.ee.ryerson.ca/~lzhao/ELE635/Chap3_AM-notes%20Part%202.pdf

    B_LPF = 200
    output_predemod_t = np.multiply(carrier_signal_t, output_t)
    LPF_t = 2 * B_LPF * np.sinc(2 * B_LPF * (time - (start_time + stop_time) / 2))
    output_demod_t = np.convolve(LPF_t, output_predemod_t, mode='same') / fs

    output_demod_f = np.fft.fftshift(abs(np.fft.fft(output_demod_t) / fs))

    plt.figure(1)
    plt.subplots_adjust(top=0.933, bottom=0.104, left=0.057, right=0.988, hspace=1.0, wspace=0.2)
    plt.subplot(4, 1, 1)
    plt.plot(time + T, message_t)
    plt.title('Message signal time domain')
    plt.xlabel('time(t)')
    plt.ylabel('Amplitude')

    plt.subplot(4, 1, 2)
    plt.plot(time + T, message_mod_ssb_t)
    plt.title('Modulated signal time domain')
    plt.xlabel('time(t)')
    plt.ylabel('Amplitude')

    plt.subplot(4, 1, 3)
    plt.plot(time + T, output_t)
    plt.title('Modulated signal after the channel time domain')
    plt.xlabel('time(t)')
    plt.ylabel('Amplitude')

    plt.subplot(4, 1, 4)
    plt.plot(time + T, output_demod_t)
    plt.title('Demodulated signal time domain')
    plt.xlabel('time(t)')
    plt.ylabel('Amplitude')

    plt.figure(2)
    plt.subplots_adjust(top=0.933, bottom=0.104, left=0.057, right=0.988, hspace=1.0, wspace=0.2)
    plt.subplot(4, 1, 1)
    plt.plot(freq_axis, message_f)
    plt.title('Message signal frequency domain')
    plt.xlabel('Frequency (Hz)')
    plt.ylabel('Magnitude')
    plt.xlim([-4 * N, 4 * N])

    plt.subplot(4, 1, 2)
    plt.plot(freq_axis, message_mod_ssb_f)
    plt.title('Modulated signal frequency domain')
    plt.xlabel('Frequency (Hz)')
    plt.ylabel('Magnitude')
    plt.xlim([-2 * f_carrier, 2 * f_carrier])

    plt.subplot(4, 1, 3)
    plt.plot(freq_axis, output_f)
    plt.title('Modulated signal after the channel frequency domain')
    plt.xlabel('Frequency (Hz)')
    plt.ylabel('Magnitude')
    plt.xlim([-2 * f_carrier, 2 * f_carrier])

    plt.subplot(4, 1, 4)
    plt.plot(freq_axis, output_demod_f)
    plt.title('Demodulated signal frequency domain')
    plt.xlabel('Frequency (Hz)')
    plt.ylabel('Magnitude')
    plt.xlim([-4 * N, 4 * N])

plt.show()
