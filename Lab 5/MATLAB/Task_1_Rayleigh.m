% PDF of Rayleigh RV

sigma = sqrt(2);
fs = 10;
xmin = 0;
xmax = 5;

% Calculating probability, mean and variance using the integral formulae
% for CDF and expectation
[total_prob,mean_val,var_val] = RayleighRV(sigma,xmin,xmax,fs);
disp('The total probability (should be 1):')
disp(total_prob)
disp('Mean for the distribution:')
disp(mean_val)
disp('Variance for the distribution:')
disp(var_val)

function [q_0,mean_val,var_val] = RayleighRV(sigma,xmin,xmax,fs)
    x = xmin:1/fs:xmax;
    pdf = x.*exp(-(x).^2/(2*(sigma)^2))/(sigma^2);
    pdf_fn = @(t)t.*exp(-(t).^2/(2*(sigma)^2))/(sigma^2);
    exp_x_fn = @(t)t.^2.*exp(-(t).^2/(2*(sigma)^2))/(sigma^2);
    exp_xsq_fn = @(t)t.^3.*exp(-(t).^2/(2*(sigma)^2))/(sigma^2);

    figure()
    plot(x,pdf)

    title("Rayleigh RV")
    xlabel("Running variable")
    ylabel("PDF")
    grid on

    q_0 = integral(pdf_fn,0,inf);
    mean_val = integral(exp_x_fn,0,inf);
    var_val = integral(exp_xsq_fn,0,inf) - mean_val^2;
end