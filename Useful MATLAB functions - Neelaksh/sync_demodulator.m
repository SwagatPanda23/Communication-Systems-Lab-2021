function sync_dem=sync_demodulator(am_t, fc, t, Ac)
    sync_carr = Ac*cos(2*pi*fc*t);
    sync_dem = am_t.*sync_carr;
end