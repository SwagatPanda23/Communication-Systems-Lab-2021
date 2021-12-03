function switch_mask=sign_switch_ifft(y_t, tol)
    switch_mask = [];
    switch_count = 0;
    for i=y_t
        if (i < 0 + tol) && (i > 0 - tol)
            switch_count = 1 + switch_count;
        end
        if mod(switch_count, 2) ~= 0
            switch_mask = [switch_mask, -1];
        else
            switch_mask = [switch_mask, 1];
        end
    end
end
            