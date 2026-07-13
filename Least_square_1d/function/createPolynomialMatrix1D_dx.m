function A = createPolynomialMatrix1D_dx(x_data, n)
    % Build the design matrix for the *negated derivative* of a degree-n
    % polynomial in 1D, i.e. A(:, i+1) = -i * x_data.^(i-1).
    %
    % The negation lets the caller express the monotonicity constraint
    % dy/dx >= 0 directly in lsqlin's "A * a <= b" form (with b = 0):
    %   A * a <= 0  <=>  -dy/dx <= 0  <=>  dy/dx >= 0
    %
    %   Inputs:
    %     x_data - data vector
    %     n      - maximum degree of x
    %   Output:
    %     A - negated-derivative fitting matrix

    num_data = length(x_data);
    A = zeros(num_data, n + 1);

    A(:, 1) = 0;  % derivative of the constant term is zero
    for i = 1:n
        A(:, i+1) = -i * x_data.^(i-1);
    end
end
