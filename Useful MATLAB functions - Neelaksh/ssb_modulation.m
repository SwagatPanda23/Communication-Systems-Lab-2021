function m_ssb_t=ssb_modulation(m_t, fc, t_axis, Ac, band)
    hilbert = (1/pi)./t_axis;
    mh_t = conv(m_t, hilbert, 'same');
    cos_carr = Ac*cos(2*pi*fc*t_axis);
    sin_carr = Ac*sin(2*pi*fc*t_axis);
    m_ssb_t = m_t.*cos_carr + band*mh_t.*sin_carr;
end
