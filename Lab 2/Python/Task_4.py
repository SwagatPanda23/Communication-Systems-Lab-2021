import numpy as np
import math
import matplotlib.pyplot as plt
from scipy.io import wavfile
from playsound import playsound
import os

# Dial tone

fs1 = 44100
t_start = 0
t_stop = 0.5
ts = 1/fs1
t1 = np.arange(t_start, t_stop, ts)

fd1 = 440
fd2 = 350

dial_tone = 0.1*np.sin(2*math.pi*fd1*t1) + 0.1*np.sin(2*math.pi*fd2*t1)

dir_name = os.getcwd()
dir_name_new = '{}'.format(dir_name).replace('\\', '/')
filename = "dial_tone.wav"
dir_name_final = dir_name_new + '/' + filename
print(dir_name_final)
wavfile.write(filename, fs1, dial_tone)
playsound(dir_name_final)

plt.figure(1)
plt.plot(t1, dial_tone)
plt.title("Time Domain Plot - Dial Tone")
plt.xlabel("Time(s)")
plt.ylabel("Amplitude")

axes = plt.gca()
axes.set_xlim([0, 0.5])
axes.set_ylim([-0.3, 0.3])
plt.show()
