import numpy as np
import matplotlib.pyplot as plt
import math
import wave
from scipy.io import wavfile
from playsound import playsound
import os


# Reading the audio file
file = wave.open('Music.wav')
fs_audio = file.getframerate()
n_frames = file.getnframes()
audio_duration = n_frames/float(fs_audio)

# Use int32 as the datatype while extracting binary data from the audio file, else it loses out information and when it is played, it gets reflected.
data = file.readframes(-1)
message_init = np.frombuffer(data, np.int32)
message_data = message_init
message_noisy = np.array(message_data, dtype='int32')

time_endpt = int(audio_duration)
for T in range(time_endpt):

    # Defining all the common parameters for each second
    start_time = 0
    stop_time = 1
    fs = fs_audio
    ts = 1/fs
    time = np.arange(start_time, stop_time, ts)

    # Generating the message signal
    message_t = message_data[T*fs:fs*(T + 1)]
    # Modelling the Channel - Choose the bandwidth such that all the frequencies are captured.
    B = 20000
    channel_t = 2 * B * np.sinc(2 * B * (time - (-start_time + stop_time)/2))

    plt.figure(1)
    plt.plot(time + T, message_t)
    plt.title('Message - Time Domain')
    plt.xlabel('Time')
    plt.ylabel('Amplitude')

    # Modelling noise
    mu = 0  # Sum of last two digits of ID
    sigma_square = 4  # Sum of last three digits of ID
    sigma = math.sqrt(sigma_square)

    noise = mu + sigma * np.random.randn(len(message_t))

    # Modify the amplitude of the noise signal and see the effect
    # The max(message_data) was multiplied to make the noise significant enough and observe it's effect. 
    # We could've normalised the message_data vector too but that does not play well enough in sound, so keep it unchanged and instead scale up the noise.
    output_t = np.convolve(message_t, channel_t, mode='same')/fs + 0.01*max(message_data)*noise
    message_noisy[T * fs:fs*(T + 1)] = output_t

    plt.figure(2)
    plt.plot(time + T, output_t)
    plt.title('Output - Time Domain')
    plt.xlabel('Time')
    plt.ylabel('Amplitude')

    # plt.pause(1)

plt.show()

dir_name = os.getcwd()
dir_name_new = '{}'.format(dir_name).replace('\\', '/')
filename = "Noisy Music.wav"
dir_name_final = dir_name_new + '/' + filename
wavfile.write(filename, fs_audio, message_noisy)
playsound(dir_name_final)
