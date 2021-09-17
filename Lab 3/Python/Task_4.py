import numpy as np
import matplotlib.pyplot as plt

def rect_pulse(end_rectpulse, time_axis_start, time_axis_stop, time_sampling):

	time = np.arange(time_axis_start, time_axis_stop, time_sampling)
	return np.where(abs(time)<=end_rectpulse/2, 1, 0)


Amplitude = 0.1
B = 10 # Frequency limit on one side of the pulse
t_start = -5
t_end = 5
fm = B
fs = 10*fm
ts = 1/fs

#Channel modelling
t = np.arange(t_start, t_end, ts)
sinc_pulse = Amplitude*2*B*np.sinc(2*B*t)  # BP LATHI: mt= 2*B*sinc(2*B*pi*t);


# Message signal
pulse_width = 1
message = rect_pulse(pulse_width, t_start, t_end, ts)


plt.figure(1)

plt.plot(t, message, color='blue')
plt.xlabel('Time')
plt.ylabel('Rect Pulse(t)')
plt.title('Time domain: Rectangular Pulse')
plt.grid(True, which='both')
plt.axhline(y=0, color='m')

axes = plt.gca()
axes.set_xlim([t_start, t_end])
# axes.set_ylim([None, None])

# Convolution and normalizing
output_signal = np.convolve(message, sinc_pulse, mode='same')
output_signal_final = output_signal/fs

# Plotting
plt.figure(2)

plt.subplot(1,2,1)
plt.plot(t, message, color='red')
plt.subplots_adjust(left=0.1, bottom=0.1, right=0.9, top=0.9, wspace=0.5, hspace=0.5)
plt.xlabel('Time')
plt.ylabel('message(t)')
plt.title('Time Domain: Message signal')
plt.grid(True, which='both')
plt.axhline(y=0, color='m')

# axes = plt.gca()
# axes.set_xlim([-40/B, 40/B])
# axes.set_ylim([None, None])

plt.subplot(1,2,2)
plt.plot(t, output_signal_final,color='green')
plt.xlabel('Time')
plt.ylabel('output(t)')
plt.title('Time Domain: Output Signal')
plt.grid(True, which='both')
plt.axhline(y=0, color='m')

# axes = plt.gca()
# axes.set_xlim([-40/B, 40/B])
# axes.set_ylim([None, None])


num_samples = fs*(t_end - t_start)

frequency_axis = np.linspace(-fs/2, fs/2, num_samples)

# FFT of the channel
fourier_channel = np.fft.fft(sinc_pulse)
fourier_1_channel = np.abs(fourier_channel/fs)
fourier_2_channel = np.fft.fftshift(fourier_1_channel)

# FFT of the message
fourier_message = np.fft.fft(message)
fourier_1_message = np.abs(fourier_message/fs)
fourier_2_message = np.fft.fftshift(fourier_1_message)

# Multiplication in Frequency domain
fourier_output = np.multiply(fourier_2_message,fourier_2_channel)

# Plotting
plt.figure(3)

plt.subplot(1,2,1)
plt.subplots_adjust(left=0.1, bottom=0.1, right=0.9, top=0.9, wspace=0.5, hspace=0.5)
plt.plot(frequency_axis, fourier_2_message, color='red')
plt.xlabel("Frequency(Hz)")
plt.ylabel("Message(f)")
plt.title("Frequency Domain: Message Signal")
plt.grid(True, which='both')

# axes = plt.gca()
# axes.set_xlim([-B, B])
# axes.set_ylim([None, None])

plt.subplot(1,2,2)
plt.plot(frequency_axis, fourier_output, color='green')
plt.xlabel("Frequency(Hz)")
plt.ylabel("Output(f)")
plt.title("Frequency Domain: Output Signal")
plt.grid(True, which='both')

# axes = plt.gca()
# axes.set_xlim([-2*B, 2*B])
# axes.set_ylim([None, None])


plt.show()