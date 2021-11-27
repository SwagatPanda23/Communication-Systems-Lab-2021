close all;
%% IMPORTANT PARAMETERS

NAME = 'Wolfgang';
AWGN_SIGMA = 0.1; 
BITRATE = 2; % 2 pulses ps
PLOT_LC = true;
RES = 200; % should be an integer.
BAND_LIMITED = true;
B = 10; % For 2*B*sinc(2*B*t).
MF_CONV_SAME = false; % true => conv(..., 'same') in MF
REMOVE_OVERLAP = true; % true => will remove the symbol overlap if 
% MF_CONV_SAME = false.
% Note that removing overlap is not conceptually correct since the
% convolution will introduce ISI.
%% BINARY ENCODING
% Discussed in previous lab sessions.
close all;

name_bin = dec2bin(NAME);
name_bin_dim = size(name_bin);
% MATLAB uses Column Major convention to represent numbers in an array.
serial_bin = reshape(name_bin, 1, []);

NUM_BITS = name_bin_dim(2);
T_END = numel(serial_bin)/BITRATE;
% Now, to convert the serial bit sequence to integer: Since each bit is the
% char '1' or '0'. One can perform arithmatric operations on char, their
% value is the ASCII value assigned to the character. ASCII('1') =
% ASCII('0') + 1.
serial_bin = serial_bin - '0';
% Converting to Polar NRZ code. One can skip the previous step by replacing
% the 1 by '1' in line 15 of pnrz() function.
[t_vec, line_code] = pnrz(serial_bin, BITRATE, RES);

if PLOT_LC
    figure(1)
    plot(t_vec, line_code, "Color",'k');
    hold on;
    plot(t_vec, zeros([1, numel(t_vec)]), 'LineWidth',1,'Color','b');
    hold off;
    title("Polar NRZ Code of the Signal");
    ylim([-2 2])
    xlim([t_vec(1), t_vec(end)])
    grid on;
end

%% REAL TIME TRANSMISSION

Fs = RES*BITRATE;
tpb = 1/BITRATE; % Time Per Bit.
t_end_int = floor(t_vec(end));

bit_stream = [];
recd_signal_t = [];
m_t = [];
K = 1;
No = AWGN_SIGMA;
count = 0;

for i=serial_bin
    t0 = (0:1/Fs:(tpb-1/Fs));
    mid_idx = ceil(numel(t0)/2); % Mid point of the pulse.
    t = t0 + count*tpb;
    t_mid = t(mid_idx);
    count = count + 1;
    w = tpb;

    if i==1
        mi_t = rectpuls(t - t_mid, tpb);
    else
        mi_t = -rectpuls(t - t_mid, tpb);
    end
    

    m_t = [m_t, mi_t];
    
    awgn_t = AWGN_SIGMA*randn(1, numel(mi_t));
    if ~BAND_LIMITED
        y_t = mi_t + awgn_t;
    else
        t_sinc = t0 - (tpb - 1/Fs)/2;
        h_t = 2*B*sinc(2*B*t_sinc);
        y_t = conv(h_t, mi_t, 'same') + awgn_t;
    end
    
    % Matched Filtering.
    
    f_t = abs(flip(mi_t)); % It is simply the flipped +ve pulse. It is assumed to be known at the receiver.
    % Since the pulse is a standard unit.

    if MF_CONV_SAME
        y_mf_t = conv(y_t, f_t, 'same');
        t_mf = t;
    else
        y_mf_t = conv(y_t, f_t, 'full');
        if REMOVE_OVERLAP
            t_mf = linspace(0, 2*tpb, numel(y_mf_t)) + count*2*tpb;
        else
            t_mf = linspace(-tpb, tpb, numel(y_mf_t)) + t(1);
        end
        mid_idx = 2*mid_idx;
    end
    
    decision_value = y_mf_t(mid_idx); % Detecting bit by mid point.
    if decision_value > 0
        bit_stream = [bit_stream, 1];
    else
        bit_stream = [bit_stream, 0];
    end

    figure(2)

    subplot(2,2,1)
    hold all;
    plot(t, mi_t);
    plot(t, zeros([1, numel(mi_t)]), 'Color', 'k');
    title('Real Time PNRZ');
    ylim([-2, 2]);
    xlim([t_vec(1), t_vec(end)]);
    grid on;

    subplot(2,2,2)
    hold all;
    plot(t, y_t);
    plot(t, zeros([1, numel(y_t)]), 'Color', 'k');
    title('PNRZ after noisy channel');
    % ylim([-2, 2]);
    xlim([t_vec(1), t_vec(end)]);
    grid on;

    subplot(2,2,3)
    hold all;
    plot(t_mf, y_mf_t);
    plot(t_mf, zeros([1, numel(y_mf_t)]), 'Color', 'k');
    title('MF Output');
    xlim([-Inf, Inf]);
    grid on;

    subplot(2,2,4)
    stem(bit_stream, 'Color','k');
    title('Received Bit Stream');
    ylim([-2, 2]);
    xlim([0, numel(serial_bin)]);
    grid on;

    pause(1/BITRATE)
end

%% DECODING RECEIVED BIT STREAM
bin_stream_char = reshape(dec2bin(bit_stream), 1, []);
recd_name_bin = reshape(bin_stream_char, [], NUM_BITS);
recd_name = reshape(char(bin2dec(recd_name_bin)),1,[]);
disp("-----------------------------------------------");
disp("The Received name is: ");
disp(recd_name);
disp("-----------------------------------------------");
