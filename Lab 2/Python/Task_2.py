import cmath
import matplotlib.pyplot as plt

# Wireless Channel modelling

G_t = 10
G_r = 1
c = 3*10**8
P_t = 1

freq1 = 9*10**8
freq2 = 24*10**8
# 900 MHz and 2.4 GHz


fig = plt.figure(figsize=(3, 3))
P_r1 = []
P_r2 = []
d = []
for i in range(0, 20):
    di = 100 + 250*i
    d.append(di)
    P_r1.append(10 * cmath.log10(P_t * 10 ** 3 * ((G_t * G_r * c ** 2) / (4 * cmath.pi * freq1 * di) ** 2)))
    P_r2.append(10 * cmath.log10(P_t * 10 ** 3 * ((G_t * G_r * c ** 2) / (4 * cmath.pi * freq2 * di) ** 2)))

plt.plot(d, P_r1, 'o-', label='900 MHz')
plt.plot(d, P_r2, 'o-', label='2.4 GHz')
plt.title('Received power(mdB) vs Distance at two frequencies')
plt.xlabel('Distance (m)')
plt.ylabel('Received power (mdB)')
plt.grid(True, which='both')
plt.axhline(y=0, color='m')
plt.legend(loc='upper right')

axes = plt.gca()
axes.set_xlim([0, None])
axes.set_ylim([None, None])

plt.show()
