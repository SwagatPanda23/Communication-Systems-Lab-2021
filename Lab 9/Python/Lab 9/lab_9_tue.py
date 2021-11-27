import numpy as np
import scipy as sci
import sys
sys.path.insert(1, '../Utils/')
import std_functions as sf
import matplotlib.pyplot as plt

##### TASK 1 #####

N = 10
Fs = 1000
T_START = 0
T_END = 0.5
t = np.linspace(T_START, T_END, int((T_END - T_START)*Fs))
# Signal
m_t = N*np.cos(2*N*np.pi*t)
# Number of quantization levels
L = 8
m_min = np.min(m_t)
m_max = np.max(m_t)
Delta = (m_max - m_min)/L
# To change Delta as mentioned in the question, change L.
# What do you expect on increasing L? 
# Note that, there are L quantization regions, divided by
# L - 1 quantization levels. Each quantization region is given a value, its
# quantum. This record is maintained in the codebook. The separation levels
# are contained in the partitions. Therefore, codebook contains one element
# more than the partition.
partitions = np.linspace(m_min, m_max - Delta, L - 1)
codebook = np.linspace(m_min, m_max, L)
index, quants = sf.quantiz(m_t, partitions, codebook)
n = np.ceil(np.log2(L))
y = sf.uencode(quants, n)

plt.plot(t, m_t, 'r-', t, quants, 'k.', linewidth=2)
plt.xlabel('Time (sec)')
plt.ylabel('m(t)')
plt.legend(['Actual Signal','Quantized Signal'])
plt.title("PCM Encoding")
plt.grid(True, which="both")
plt.show()

#### TASK 2 ####
N = 10
Fs = 500
T_START = 0
T_END = 0.8
DELTA = 2

t = np.linspace(T_START, T_END, int((T_END - T_START)*Fs))
# Signal
m_t = N*np.sin(2*N*np.pi*t)
frac = 0.5
Fs_dm = Fs*frac

dm_t, bit_stream, index = sf.delta_modulation(m_t, Fs, Fs_dm, DELTA)
t_bits = t[index]

print(bit_stream)
# Plotting the results
fig, axs = plt.subplots(2,1)
axs[0].plot(t, m_t, 'r-', t, dm_t, 'k-')
axs[0].set_title("Actual v/s DM Modulated, Delta: {0} | Fs_dm: {1}*Fs".format(DELTA, frac))
axs[0].legend(['Actual Signal', 'DM Modulated'])
axs[1].stem(t_bits, bit_stream)
axs[1].set_title("The Corresponsing Bit Stream")

for ax in axs.flat:
    ax.set(xlabel='Time (s)', ylabel='Value')
    ax.label_outer()

fig.tight_layout()
plt.show()