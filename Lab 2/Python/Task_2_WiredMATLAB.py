# import numpy as np
import cmath
import matplotlib.pyplot as plt

# Wireline Channel modelling - 0.40 mm wire

R_oc = 280
a_c = 0.0969
L_0 = 587.3*10**(-6)
L_inf = 426*10**(-6)
b = 1.385
f_m = 745900
C_inf = 50*10**(-9)
C_0 = 0*10**(-9)
c_e = 1
g_0 = 0
g_e = 1


# Part 1
freq = [4, 4000, 4000000]*10**3
# 4k, 4M and 4GHz

num_rows = 2
num_cols = 1
counter = 1


fig = plt.figure(figsize=(3, 3))
plt.subplots_adjust(left=0.1, bottom=0.1, right=0.9, top=0.9, wspace=0.5, hspace=0.5)

for f in freq:
    if counter <= num_rows*num_cols:
        R1 = (R_oc**4 + a_c*f**2)**(1/4)
        L1 = (L_0 + L_inf*(f/f_m)**b)/(1 + (f/f_m)**b)
        G1 = g_0 * f ** g_e
        C1 = C_inf + C_0*f**(- c_e)

        omega1 = 2*cmath.pi*f
        gamma1 = cmath.sqrt((R1 + 1j*L1*omega1)*(G1 + 1j*C1*omega1))

        d1 = []
        H1 = []
        for i in range(9):
            di = 10 + (i - 1)*500
            d1.append(di)
            H1.append(10*cmath.log10(abs(cmath.e**(-gamma1*di/1000))))

        plt.subplot(num_rows, num_cols, counter)
        plt.plot(d1, H1, 'o-')
        plt.title('Subplot {}: Relation of H(f) with Distance at a fixed frequency of {} kHz'.format(counter, f))
        plt.xlabel('Distance (m)')
        plt.ylabel('Received power (mdB)')
        plt.grid(True, which='both')
        plt.axhline(y=0, color='m')

        axes = plt.gca()
        axes.set_xlim([0, None])
        axes.set_ylim([None, None])

        counter = counter + 1
    else:
        break

plt.show()
