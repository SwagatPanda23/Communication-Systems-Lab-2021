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
    A = 2  # Carrier Amplitude
    f_carrier = 1000  # different from the problem statement to avoid the upper-lower sideband interference
    beta = 20
    Am_max = 10
    Am_min = 1
    Am = np.random.randint(Am_min, Am_max + 1)
    kf = 2 * math.pi * beta * (2 * Am) / (2 * Am)
    B_sig = 2 * (2 * Am_max) * (beta + 1)
    fs = 10 * B_sig
    ts = 1 / fs
    time = np.arange(start_time, stop_time, ts)
    # Because the min of the largest sinc pulse for this case is ~ -21,
    # hence for the envelope detector to work the carrier amplitude must be greater than this.

    len_time = len(time)
    freq_axis = np.linspace(-fs / 2, fs / 2, len_time)

    # Defining the message signal
    B = Am
    message_t = 2 * B * np.sinc(2 * B * (time - (start_time + stop_time) / 2))
    message_integrated_t = ts * np.cumsum(message_t)
    message_f = np.fft.fftshift(abs(np.fft.fft(message_t) / fs))

    # Carrier Signal
    carrier_signal_t = A * np.cos(2 * math.pi * f_carrier * time)
    carrier_signal_f = np.fft.fftshift(abs(np.fft.fft(carrier_signal_t) / fs))

    # Modulating the message signal
    message_mod_t = A * np.cos(2 * math.pi * f_carrier * time + kf * message_integrated_t)
    message_mod_f = np.fft.fftshift(abs(np.fft.fft(message_mod_t) / fs))

    # Modelling noise
    mu = 0
    sigma_square = 10**(-6)
    sigma = np.sqrt(sigma_square)
    noise = mu + sigma * np.random.randn(len(message_t))

    # Modelling the Channel
    a = 0.5

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

    # Demodulation using Hilbert detector - uncomment any one at a time to run.
    # Method 1 - From BP Lathi

    # output_predemod_t = np.diff(output_t, prepend=output_t[0])/(ts * kf)
    # output_demod_t = np.abs(signal.hilbert(output_predemod_t)) - np.mean(np.abs(signal.hilbert(output_predemod_t)))
    # output_demod_f = np.fft.fftshift(abs(np.fft.fft(output_demod_t) / fs))

    # Method 2 -
    # https://www.gaussianwaves.com/2017/06/phase-demodulation-using-hilbert-transform-application-of-analytic-signal/

    output_predemod_t = signal.hilbert(output_t)  # form the analytical signal from the received vector
    inst_phase = np.unwrap(np.angle(output_predemod_t))  # instantaneous phase

    # If receiver doesn't know the carrier, estimate the subtraction term

    receiverKnowsCarrier = True
    if receiverKnowsCarrier:
        offsetTerm = 2 * math.pi * f_carrier * time  # if carrier frequency & phase offset is known
        output_predemod_t = (inst_phase - offsetTerm) / (kf * ts)
        output_demod_t = np.diff(output_predemod_t, prepend=output_predemod_t[0])
    else:
        p = np.poly1d(np.polyfit(time, inst_phase, 1))  # linearly fit the instantaneous phase
        offsetTerm = p(time)  # re-evaluate the offset term using the fitted values
        output_predemod_t = (inst_phase - offsetTerm) / (kf * ts)
        output_demod_t = np.diff(output_predemod_t, prepend=output_predemod_t[0])

    output_demod_f = np.fft.fftshift(abs(np.fft.fft(output_demod_t) / fs))

    # Some samples from the beginning and the end of the signal are removed while plotting the demodulated signal,
    # because the np.diff() function doesn't act on the first and the last term, hence leaving some edge residues.
    plt.figure(1)
    plt.subplots_adjust(top=0.933, bottom=0.104, left=0.057, right=0.988, hspace=1.0, wspace=0.2)
    plt.subplot(4, 1, 1)
    plt.plot(time + T, message_t)
    plt.title('Message signal time domain')
    plt.xlabel('time(t)')
    plt.ylabel('Amplitude')

    plt.subplot(4, 1, 2)
    plt.plot(time + T, message_mod_t)
    plt.title('Modulated signal time domain')
    plt.xlabel('time(t)')
    plt.ylabel('Amplitude')

    plt.subplot(4, 1, 3)
    plt.plot(time + T, output_t)
    plt.title('Modulated signal after the channel time domain')
    plt.xlabel('time(t)')
    plt.ylabel('Amplitude')

    plt.subplot(4, 1, 4)
    plt.plot(time[int(fs * 0.001):-int(fs * 0.001)] + T, output_demod_t[int(fs * 0.001):-int(fs * 0.001)])
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
    plt.plot(freq_axis, message_mod_f)
    plt.title('Modulated signal frequency domain')
    plt.xlabel('Frequency (Hz)')
    plt.ylabel('Magnitude')
    plt.xlim([-(f_carrier + 2 * B_sig), f_carrier + 2 * B_sig])

    plt.subplot(4, 1, 3)
    plt.plot(freq_axis, output_f)
    plt.title('Modulated signal after the channel frequency domain')
    plt.xlabel('Frequency (Hz)')
    plt.ylabel('Magnitude')
    plt.xlim([-(f_carrier + 2 * B_sig), f_carrier + 2 * B_sig])

    plt.subplot(4, 1, 4)
    plt.plot(freq_axis[int(fs * 0.001):-int(fs * 0.001)], output_demod_f[int(fs * 0.001):-int(fs * 0.001)])
    plt.title('Demodulated signal frequency domain')
    plt.xlabel('Frequency (Hz)')
    plt.ylabel('Magnitude')
    plt.xlim([-4 * N, 4 * N])

plt.show()
