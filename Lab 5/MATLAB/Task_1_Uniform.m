% PDF of Uniform RV

b = 4;
a = 1;
fs = 10;

% Calculating probability, mean and variance using the integral formulae
% for CDF and expectation
[total_prob, mean_val,var_val] = UniformRV(b,a,fs);
disp('The total probability (should be 1):')
disp(total_prob)
disp('Mean for the distribution:')
disp(mean_val)
disp('Variance for the distribution:')
disp(var_val)

function [q_0,mean_val,var_val] = UniformRV(b,a,fs)
    x = a:1/fs:b;
    pdf = zeros(1, numel(x));
    for i = 1:1:numel(x)
        if( (x(i) >= a)&&(x(i) <= b))
            pdf(i) = 1/(b - a);
        else
            pdf(i) = 0;
        end
    end
    pdf_fn = @(t) t.^0.*1/(b - a);
    exp_x_fn = @(t)t.*(1/(b - a));
    exp_xsq_fn = @(t)t.^2.*(1/(b - a));

    figure()
    plot(x,pdf)
    axis([a-2 b+2 0 4/(b-a)])
    title("Uniform RV")
    xlabel("Running variable")
    ylabel("PDF")
    grid on

    q_0 = integral(pdf_fn,a,b);
    mean_val = integral(exp_x_fn,a,b);
    var_val = integral(exp_xsq_fn,a,b) - mean_val^2;
end