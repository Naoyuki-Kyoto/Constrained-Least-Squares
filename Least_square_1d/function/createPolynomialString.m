function poly_str = createPolynomialString(coeff, n)
    % Build a human-readable string "a0 + a1*x^1 + ... + an*x^n" for a
    % polynomial with the given coefficients.
    %   Inputs:
    %     coeff - coefficient vector, coeff(i+1) is the coefficient of x^i
    %     n     - maximum degree of x
    %   Output:
    %     poly_str - formatted polynomial string

    poly_str = "";

    for i = 0:n
        current_coeff = coeff(i+1);
        if i == 0
            if current_coeff < 0
                poly_str = poly_str + sprintf(" - %g", abs(current_coeff));  % negative constant term
            else
                poly_str = poly_str + sprintf("%g", current_coeff);         % positive constant term
            end
        else
            if current_coeff < 0
                poly_str = poly_str + sprintf(" - %g*x^%d", abs(current_coeff), i);  % negative term
            else
                poly_str = poly_str + sprintf(" + %g*x^%d", current_coeff, i);       % positive term
            end
        end
    end
end