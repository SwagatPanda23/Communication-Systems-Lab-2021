import math
import random
import wave
import matplotlib.pyplot as plt
import numpy as np
from playsound import playsound

last_digit_id = 3


def rect_pulse(time, pulse_width):
	return np.where(abs(time) <= pulse_width/2, 1, 0)


def select_message(time, num, start_time, stop_time):
	message = []
	message.extend([np.cos(2*math.pi*last_digit_id*time),
					2*last_digit_id*np.sinc(2*last_digit_id*(time - (start_time + stop_time)/2)),
					rect_pulse(time - (start_time+stop_time)/2, last_digit_id)])
	return message[num]


one_time_rnd_num = random.randint(0,3)

time_endpt = 30

if one_time_rnd_num == 3:
	file = wave.open('Music.wav')
	fs_audio = file.getframerate()
	n_frames = file.getnframes()
	audio_duration = n_frames/float(fs_audio)

	data = file.readframes(-1)
	mat_data_init = np.frombuffer(data, np.int16)
	mat_data = mat_data_init/max(mat_data_init)
	
	for T in range(int(audio_duration)+1):
		# Defining all the common parameters for each second
		start_time = 0
		stop_time = 1
		ts = 1/float(fs_audio)
		time = np.arange(start_time, stop_time, ts)

		message_t = mat_data[T*fs_audio:fs_audio*(T+1)]
		N = len(message_t)
		freq_axis = np.linspace(-fs_audio/2, fs_audio/2, N)

		message_f = np.fft.fftshift(np.abs(np.fft.fft(message_t)/fs_audio))

		plt.figure(1)
		plt.plot(time + T, message_t.T)
		plt.title('Time Domain')
		plt.xlabel('Time')
		plt.ylabel('Amplitude')

		plt.figure(2)
		plt.plot(freq_axis.T, message_f)
		plt.title('Frequency Domain')
		plt.xlabel('Frequency')
		plt.ylabel('Amplitude')

		# plt.pause(1)
	plt.show()
	playsound('Music.wav')

else:
	for T in range(time_endpt):
		# Defining all the common parameters for each second
		start_time = 0
		stop_time = 1
		fm = last_digit_id   # Maximum frequency component in Hertz for the given spectrum - Last digit of ID number goes here
		fs = 100*fm
		ts = 1/fs
		time = np.arange(start_time, stop_time, ts)

		# Generating the message signal
		message_t = select_message(time, one_time_rnd_num, start_time, stop_time)
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


