import numpy as np
from collections import namedtuple

# Check the documentation of named tuples for reference.
sfOpts = namedtuple('sfOpts', ('USE_SINE', 'USE_COSINE'))
SF_OPTS = sfOpts(USE_SINE = 1,
                USE_COSINE = 2)

##----##---- LAB 2 ----##----##
def P_R(P_T, G_T, G_R, L, d):
    P_R = np.zeros_like(d)
    # Check numpy array broadcasting.
    P_R[:] = P_T*G_T*G_R*(L**2)/(4*np.pi*d[:])**2
    return P_R

def db_from_W(P, mode=0):
    Po = 1 # dB
    if mode == 1:
        Po = 0.001 # dBm
    return (10*np.log(P/Po))

def W_from_dB(P, mode=0):
    Po=1 # from dB
    if mode == 1:
        Po = 0.001 # from dBm
    return (Po*np.power(10, P/10))

def calc_binary(str_):
    unicode = np.array([], dtype=np.int)
    binary = np.array([])
    bit_stream = ''
    for i in str_:
        unicode = np.append(unicode, ord(i))
        binary = np.append(binary, bin(unicode[-1]))
        bit_stream += binary[-1][2:] # remove the 0b in the front of the char sequence by array slicing.
    return unicode, binary, bit_stream   

##----##---- LAB MIDSEM ----##----##

def frequency_modulation(sig, t, Kf, Fc, Ac, csig = SF_OPTS.USE_SINE):
    """
    This function implements a simple frequency modulation scheme.
    @param [in]  sig: The input signal m(t). (V)
    @param [in]    t: Time vector used to generate sig. (sec)
    @param [in]   Kf: The FM constant Kf. (Hz/V)
    @param [in]   Ac: Amplitude of the carrier signal. (V)
    @param [in] csig: The carrier signal to be used. Sine by default. [SF_OPT]
    
    @param [out] fm_t: The frequency modulated signal.
    """
    assert(len(sig) == len(t))
    assert(Kf > 0)
    sig = np.array(sig)
    t = np.array(t)
    fm_sig = np.zeros_like(sig)
    # dt at all instants
    dt = np.diff(t, n=1, append=t[-1])
    m_dt = np.zeros_like(sig)
    # m(t)*dt at all instants
    m_dt[:] = sig[:]*dt[:]
    # integrating m(t) w.r.t dt
    i_m_dt = np.cumsum(m_dt)
    
    # Making the FM Modulated signal.
    if csig == SF_OPTS.USE_SINE:
        fm_sig[:] = Ac*np.sin(2*np.pi*(Fc*t[:] + Kf*m_dt[:]))
        
    elif csig == SF_OPTS.USE_COSINE:
        fm_sig[:] = Ac*np.cos(2*np.pi*(Fc*t[:] + Kf*m_dt[:]))
    
    else:
        return 0
    return fm_sig
    
def channel_att(G, lam, d):
    """
    Channel attenuation formulae given in the problem statement.
    """
    return G*lam/(4*np.pi*d)

def signal_power(sig):
    """
    Calculates the statistical signal power E[m^2]
    """
    sig = np.array(sig)
    sig_pow = np.mean(np.square(sig))
    return sig_pow

##----##---- LAB 9 ----##----##

def quantiz(sig, partition, codebook):
    """
    This function is the python alternative of the MATLAB quantiz 
    function as was written using the MATLAB documentation for
    quantiz.
    """
    assert(len(codebook) == len(partition) + 1)
    
    sig = np.array(sig)
    partition = np.array(partition)
    codebook = np.array(codebook)
    
    index = np.zeros_like(sig)
    quants = np.zeros_like(sig)
    count = 0
    
    for sample in sig:
        idx = 0
        while (idx < len(partition)) and (sample > partition[idx]):
            idx = idx + 1
        index[count] = idx
        quants[count] = codebook[idx]
        count = count + 1
    
    return index, quants

def uencode(u, n):
    """
    This function is the python alternative of the MATLAB uencode 
    function as was written using the MATLAB documentation for
    uencode.
    """
    # There are 2^n levels of quantizations, each level no. l is assigned 
    # a value of l itself. This is basically quantizing with 2^n 
    # partitions by 2^n-1 partition levels.
    u = np.array(u)
    u_min = np.min(u)
    u_max = np.max(u)
    # 2^n partitions
    nparts = int(2**n)
    du = (u_max - u_min)/nparts
    # 2^n - 1 partition levels
    partition = np.linspace(u_min+du, u_max-du, nparts - 1)
    # codebook consisting of integers
    codebook = np.zeros(nparts)
    count = 0
    for i in codebook:
        codebook[count] = count
        count = count + 1
    
    _, quants = quantiz(u, partition, codebook)
    
    return quants

def delta_modulation(sig, fs, Fs, delta):
    """
    This function implements a simple delta modulation scheme.
    @param [in]   sig: The input signal.
    @param [in]    fs: sampling freq. of the signal.
    @param [in]    Fs: The sampling freq of the DM Modulator.
    @param [in] delta: The step size of the staircase approximation.
    
    @param [out]      dm_sig: The DM Modulated approximation of sig.
    @param [out]  bit_stream: The bit stream corresponding to dm_sig.
    @param [out]       index: The indices array for other utilities.
    """
    
    assert(Fs < fs)
    sig = np.array(sig)
    idx_skip = int(np.ceil(fs/Fs))
    n = np.ceil(len(sig)/idx_skip)
    dm_sig = np.zeros_like(sig)
    bit_stream = np.zeros(int(n))
    index = np.zeros(int(n), dtype=int)
    dm_sig[0] = sig[0]
    count = idx_skip
    i = 0
    while (count < len(sig)) and (i < n):
        cmp = sig[count] - dm_sig[count - idx_skip]
        if cmp > 0:
            dm_sig[count] = dm_sig[count - idx_skip] + delta
            bit_stream[i] = 1
        else:
            dm_sig[count] = dm_sig[count - idx_skip] - delta
            bit_stream[i] = 0
            
        index[i] = count 
        dm_sig[count + 1 : count + idx_skip] = dm_sig[count]
        count = count + idx_skip
        i = i + 1
        
    return dm_sig, bit_stream, index