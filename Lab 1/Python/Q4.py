import numpy
import math
import matplotlib.pyplot as plot

# Get x values of the sine wave
t_init = 0
t_final = 1

N = 2
fm = 10*N
fs = 10*fm
ts = 1/fs

time = numpy.arange(t_init, t_final, ts)
sine_wave = numpy.sin(2*math.pi*fm*time)
plot.plot(time, sine_wave)

# Give x axis label for the sine wave plot
plot.xlabel('Time')
plot.ylabel('Amplitude = sin(time)')
plot.grid(True, which='both')
plot.axhline(y=0, color='m')
plot.show()
