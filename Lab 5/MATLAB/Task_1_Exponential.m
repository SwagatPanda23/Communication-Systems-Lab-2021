% PDF of Exponential RV

lambda = 5;
xmin = 0;
xmax = 5;
fs = 10;

% Calculating probability, mean and variance using the integral formulae
% for CDF and expectation
[total_prob, mean_val,var_val] = ExpRV(lambda,xmin,xmax,fs);
disp(total_prob)
disp(mean_val)
disp(var_val)

function [q_0,mean_val,var_val] = ExpRV(lambda,xmin,xmax,fs)
    x = xmin:1/fs:xmax;
    pdf = lambda.*exp(-lambda.*x);
    pdf_fn = @(t)lambda.*exp(-lambda.*t);
    exp_x_fn = @(t)t.*lambda.*exp(-lambda.*t);
    exp_xsq_fn = @(t)t.^2.*lambda.*exp(-lambda.*t);

    figure()
    plot(x,pdf)

    title("Exponential RV")
    xlabel("Running variable")
    ylabel("PDF")
    grid on

    q_0 = integral(pdf_fn,0,inf);
    mean_val = integral(exp_x_fn,0,inf);
    var_val = integral(exp_xsq_fn,0,inf) - mean_val^2;
end