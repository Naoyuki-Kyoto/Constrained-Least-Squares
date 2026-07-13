function y_fit = evaluatePolynomial1D(a, x_fit, n)
    % Evaluate a degree-n polynomial with coefficients a at points x_fit.
    %   Inputs:
    %     a     - polynomial coefficient vector, a(i+1) is the coefficient of x^i
    %     x_fit - points at which to evaluate the polynomial
    %     n     - maximum degree of x
    %   Output:
    %     y_fit - polynomial evaluated at x_fit (same shape as x_fit)

    y_fit = zeros(size(x_fit));
    for i = 0:n
        y_fit = y_fit + a(i+1) * x_fit.^i;
    end
end