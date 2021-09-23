% PDF of Normal Gaussian RV

sigma = 1;
mu = 0; 
fs = 10;
xmin = -5;
xmax = 5;
xq = 1;

% Calculating probability, mean and variance using the integral formulae
% for CDF and expectation
[total_prob,mean_val,var_val] = GaussRV(mu,sigma,xmin,xmax,fs);

disp('The total probability (should be 1):')
disp(total_prob)
disp('Mean for the distribution:')
disp(mean_val)
disp('Variance for the distribution:')
disp(var_val)

function [q_0, mean_val,var_val] = GaussRV(mu,sigma,xmin,xmax,fs)
    x = xmin:1/fs:xmax;
    pdf = exp(-(x - mu).^2/(2*(sigma)^2))/(sigma*sqrt(2*pi));
    pdf_fn = @(t)exp(-(t - mu).^2/(2*(sigma)^2))/(sigma*sqrt(2*pi));
    exp_x_fn = @(t)t.*exp(-(t - mu).^2/(2*(sigma)^2))/(sigma*sqrt(2*pi));
    exp_xsq_fn = @(t)t.^2.*exp(-(t - mu).^2/(2*(sigma)^2))/(sigma*sqrt(2*pi));

    figure()
    plot(x,pdf)

    title("Gaussian RV")
    xlabel("Running variable")
    ylabel("PDF")
    grid on

    q_0 = integral(pdf_fn,-inf,inf);
    mean_val = integral(exp_x_fn,-inf,inf);
    var_val = integral(exp_xsq_fn,-inf,inf) - mean_val^2;
end