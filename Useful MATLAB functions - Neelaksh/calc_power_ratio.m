function P_ratio=calc_power_ratio(G_T, G_R, f, d)
    % G_T, G_R are antennae gains at Tx, Rx. f is in Hz,
    % d is in m
    lambda = 3*(10^8)/f;
    P_ratio = G_T*G_R*(lambda^2)/(4*pi*d)^2;
end