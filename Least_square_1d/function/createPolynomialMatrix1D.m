function A = createPolynomialMatrix1D(x_data, n)
    % Build the design matrix for a degree-n polynomial fit in 1D.
    %   Inputs:
    %     x_data - data vector
    %     n      - maximum degree of x
    %   Output:
    %     A - polynomial fitting matrix, A(:, i+1) = x_data.^i

    num_data = length(x_data);
    A = zeros(num_data, n + 1);

    for i = 0:n
        A(:, i+1) = x_data.^i;
    end
end
