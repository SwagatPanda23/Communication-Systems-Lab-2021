import numpy as np

def sinc(x):
    sinc_x = np.zeros_like(x)
    sinc_x[:] = np.sin(x[:])/x[:]
    sinc_x[np.isnan(sinc_x)] = 1
    return sinc_x

def unit_pulse_train(T_start, T_stop, T_on, T_off, ts):
    # You can use an assert statement to throw an error in case Tstop > Tstart.
    # Suddenly changing the variable name casing pattern (i.e. using zzzYyy instead of zzz_yyy) is not a very good practice, but here goes:
    intervals = int((T_stop - T_start)/(T_on+T_off)) + 1 # Greatest Integer Function + 1.
    spi = int((T_on + T_off)/ts) # samples per interval
    spi_on = int(T_on/ts) # Samples per interval for which pulse is ON
    spi_off = int(T_off/ts) # ----------------||------------------- OFF
    N = (T_stop - T_start)/ts
    t = np.linspace(T_start, T_stop, N)
    unitPulseTrain = np.zeros_like(t)
    i = 0
    while(i < intervals):
        end = (i+1)*spi
        if end > N:
            end = end - end % int(N)
        unitPulseTrain[i*spi : i*spi + spi_on] = 1
        unitPulseTrain[i*spi + spi_on : end] = 0
        i += 1
    
    return unitPulseTrain, t

def raised_cosine(t, f, b):
    h_t = np.zeros_like(t)
    sinc_t = sinc(np.pi*f*t)
    h_t[:] = sinc_t[:]*np.cos(b*np.pi*f*t[:])/(1 - (2*b*t[:]*f)**2)
    return h_t