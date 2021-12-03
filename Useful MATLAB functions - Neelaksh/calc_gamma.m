function gamma=calc_gamma(f, R_oc, a_c, L_inf, L_0, b, f_m, g_0, g_e, C_inf, C_e, C_0)
    % This function uses the empirical formulae mentioned in the
    % lab 3 pdf and calculates the gamma factor in the channel
    % gain [H(f)] equation.
    % f, f_m are in Hz. C_e, C_0 in nF/km. g_0, g_e in S/km. L_inf, L_0 in
    % mu_H/km. 
    omega = 2*pi*f;
    R_f = (R_oc^4 + (a_c*(f^2)))^0.25; % in ohm km-1
    f_ratio = (f/f_m)^b;
    L_f = (L_0 + L_inf*f_ratio)/(1 + f_ratio); % in mu_H km-1
    omega_L = omega*L_f*(10^(-6));
    G_f = g_0*(f^g_e); % S km-1
    C_f = C_inf + C_0*(f^(-C_e)); % nF
    omega_C = omega*C_f*(10^(-9));
    
    gamma = ((R_f + 1i*omega_L)*(G_f + 1i*omega_C))^0.5;
end