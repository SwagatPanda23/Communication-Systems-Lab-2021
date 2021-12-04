import sys
sys.path.insert(1, '../../Utils/')
# Because of the relative referencing used here. Run the program only
# from within its directory. Calling it from any other location will
# result in a module not found error.
import std_functions as sf
import std_signals as ss
import numpy as np
import matplotlib.pyplot as plt
from scipy import constants as cst
from scipy import signal
# Que 2:


############### QUE 1a ###############

# Preliminary Parameters

T_START = 0
T_END = 0.8
Fc = 100
Fs = 6*Fc

Ac = 100
Kf = 20
G = 10 #dBi

awgn_sigma = 6

# Message Signal
t = np.linspace(T_START, T_END, int((T_END - T_START)*Fs))

m_t = 2*np.sin(10*np.pi*t)
# FM Modulation
# For sin:
fm_t = sf.frequency_modulation(m_t, t, Kf, Fc, Ac)
# For cos: 
# fm_t = sf.frequency_modulation(m_t, t, Kf, Fc, Ac, csig=sf.SF_OPTS.USE_COSINE)

# Channel
G = sf.W_from_dB(G)
# Assuming Fc as the approx. net frequency (as Fc >>> Fm).
m_lambda = cst.c/Fc
d = 10*1000 # 10km

# Uncomment for exact analysis:
# h_t = sf.channel_att(G, m_lambda, d)*signal.unit_impulse(len(t))

# # Receiver End
# fm_r_t = np.convolve(fm_t, h_t, mode='same')
fm_r_t = sf.channel_att(G, m_lambda, d)*fm_t

# Adding Noise
awgn_t = ss.awgn(t, 0, awgn_sigma) # Can be replaced by np.random.normal()
fm_r_t = fm_r_t + awgn_t

####### QUE 1 PLOTS #######
fig, axs = plt.subplots(2,1)

axs[0].plot(t, m_t, color='blue', linestyle='-', linewidth=1, label='m(t)')
axs[0].axhline(y=0, color='r')
axs[0].set_title("m(t)")
axs[0].grid(True, which='major', color='0.50')
axs[0].grid(True, which='minor', color='0.80', linestyle='--')
axs[0].minorticks_on()

axs[1].plot(t, fm_r_t, color='black', linestyle='-', linewidth=1, label='FM(t)')
axs[1].set_title("FM Signal")
axs[1].axhline(y=0, color='m')
axs[1].grid(True, which='major', color='0.50')
axs[1].grid(True, which='minor', color='0.80', linestyle='--')
axs[1].minorticks_on()

fig.suptitle('QUE 1a', fontsize=16)

for ax in axs.flat:
    ax.set(xlabel='Time (s)', ylabel='Amplitude (V)')
    ax.label_outer()

fig.tight_layout()
# f1.show()

############### QUE 1b ###############
# Try this as well :
# https://matplotlib.org/stable/gallery/statistics/hist.html#updating-histogram-colors
# To get a clean normal distribution you need more samples.
n_samples = 1e6
n_bins = 30
f2 = plt.figure(2)
plt.hist(ss.awgn(n_samples, 0, awgn_sigma), n_bins)
plt.xlabel('AWGN (V)')
plt.ylabel('N')
plt.title("AWGN Histogram")
plt.grid(True, which="both")
f2.suptitle("QUE 1b", fontsize=16)

############### QUE 1c ###############
n_steps = 100
d_arr = np.linspace(1, 100, n_steps)*1000
snr = np.zeros_like(d_arr)
awgn_sigma = 6
count = 0
for d in d_arr:
    awgn_t = ss.awgn(t, 0, awgn_sigma) # Can be replaced by np.random.normal()
    fm_r_t = sf.channel_att(G, m_lambda, d)*fm_t + awgn_t
    P_s = sf.signal_power(fm_r_t)
    P_n = sf.signal_power(awgn_t)
    snr[count] = P_s/P_n
    count = count + 1

####### QUE 3 PLOT #######
f3 = plt.figure(3)
plt.plot(d_arr, snr, color='brown', linestyle='-', linewidth=1, label='SNR')
plt.ylabel('SNR')
plt.xlabel('Distance b/w Rx and Tx (km)')
plt.title("SNR v/s d")
plt.grid(True, which="both")
plt.axhline(y=0, color='g')
f3.suptitle("QUE 1c", fontsize=16)

plt.show()