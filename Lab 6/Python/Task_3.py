import numpy as np
import matplotlib.pyplot as plt
import math
import wave
from scipy.io import wavfile
from playsound import playsound
import os

def rect_pulse(freq, pulse_width):
    return np.where(abs(freq) <= pulse_width/2, 1, 0)


# Reading the audio file
file = wave.open('Music.wav')
fs_audio = file.getframerate()
n_frames = file.getnframes()
audio_duration = n_frames/float(fs_audio)

# Use int32 as the datatype while extracting binary data from the audio file,
# else it loses out information and when it is played, it gets reflected.
data = file.readframes(-1)
message_init = np.frombuffer(data, np.int32)
message_data = message_init
message_noisy = np.array(message_data, dtype='int32')

time_endpt = int(audio_duration)
for T in range(time_endpt):
    # Defining all the common parameters for each second
    start_time = 0
    stop_time = 1
    f_carrier = 12500
    fs = fs_audio
    ts = 1 / fs
    time = np.arange(start_time, stop_time, ts)
    # Frequency axis
    time_len = len(time)
    freq_axis = np.linspace(-fs / 2, fs / 2, time_len)

    # Defining the carrier signal
    carrier_signal_t = 2 * np.cos(2 * math.pi * f_carrier * time)
    carrier_signal_f = np.fft.fftshift(abs(np.fft.fft(carrier_signal_t)/fs))

    # Choosing a different message signal
    selector = np.random.randint(1, 4)

    # Generating the message signal
    message_t = message_data[T*fs:fs*(T + 1)]
    message_f = np.fft.fftshift(abs(np.fft.fft(message_t) / fs))

    # Modulating the message signal
    message_mod_t = np.multiply(message_t, carrier_signal_t)
    message_mod_f = np.fft.fftshift(abs(np.fft.fft(message_mod_t)/fs))

    # Modelling the channel - Multiplied with carrier to shift it to the carrier frequency.
    B1 = 10000
    channel_t = np.multiply(2 * B1 * np.sinc(2 * B1 * (time - (start_time + stop_time) / 2)), carrier_signal_t)
    # The following can also be used as an alternative method. Uncomment this and the output_f using np.multiply.
    # channel_f = rect_pulse(freq_axis, 2 * B1)  # Done using a rectangular pulse
    # channel_f = np.fft.fftshift(np.abs(np.fft.fft(channel_t)/fs)) # Done using the fft of sinc pulse
    # Either of the two ways mentioned above can be used, and they give identical results

    # Modelling noise
    mu = 0  # Sum of last two digits of ID
    sigma_square = 0.01  # Sum of last three digits of ID
    sigma = math.sqrt(sigma_square)
    noise = mu + sigma * np.random.randn(len(time))

    # Passing the modulated signal through a band limited channel
    # Modify the amplitude of the noise signal and see the effect
    output_t = np.convolve(message_mod_t, channel_t, mode='same')/fs + noise
    output_f = np.fft.fftshift(abs(np.fft.fft(output_t)/fs))
    # Alternately:
    # output_f = np.multiply(channel_f, message_mod_f)

    # Demodulation
    B_LPF = 10000
    output_predemod_t = np.multiply(output_t, carrier_signal_t)
    LPF_t = 2 * B_LPF * np.sinc(2 * B_LPF * (time - (start_time + stop_time) / 2))
    output_demod_t = np.convolve(LPF_t, output_predemod_t, mode='same')/fs

    output_predemod_f = np.convolve(output_f, carrier_signal_f / 2, mode='same')
    LPF_f = rect_pulse(freq_axis, 2 * B_LPF)
    output_demod_f = np.multiply(output_predemod_f, LPF_f)

    message_noisy[T * fs:fs * (T + 1)] = output_demod_t

    # Time domain plots
    plt.figure(1)
    plt.subplots_adjust(top=0.933, bottom=0.104, left=0.051, right=0.988, hspace=0.798, wspace=0.2)
    plt.subplot(3, 1, 1)
    plt.plot(time + T, message_t)
    plt.title('Message - Time Domain')
    plt.xlabel('Time')
    plt.ylabel('Amplitude')

    plt.subplot(3, 1, 2)
    plt.plot(time + T, message_mod_t)
    plt.title('Modulated Output - Time Domain')
    plt.xlabel('Time')
    plt.ylabel('Amplitude')

    plt.subplot(3, 1, 3)
    plt.plot(time + T, output_demod_t)
    plt.title('Demodulated Output - Time Domain')
    plt.xlabel('Time')
    plt.ylabel('Amplitude')

    # Frequency domain plots
    plt.figure(2)
    plt.subplots_adjust(top=0.933, bottom=0.104, left=0.051, right=0.988, hspace=0.798, wspace=0.2)
    plt.subplot(3, 1, 1)
    plt.plot(freq_axis, message_f)
    plt.title('Message - Frequency Domain')
    plt.xlabel('Frequency')
    plt.ylabel('Amplitude')

    plt.subplot(3, 1, 2)
    plt.plot(freq_axis, message_mod_f)
    plt.title('Modulated Output - Frequency Domain')
    plt.xlabel('Frequency')
    plt.ylabel('Amplitude')

    plt.subplot(3, 1, 3)
    plt.plot(freq_axis, output_demod_f)
    plt.title('Demodulated Output - Frequency Domain')
    plt.xlabel('Frequency')
    plt.ylabel('Amplitude')

    # plt.pause(1)

plt.show()

dir_name = os.getcwd()
dir_name_new = '{}'.format(dir_name).replace('\\', '/')
filename = "Noisy Music.wav"
dir_name_final = dir_name_new + '/' + filename
wavfile.write(filename, fs_audio, message_noisy)
playsound(dir_name_final)

