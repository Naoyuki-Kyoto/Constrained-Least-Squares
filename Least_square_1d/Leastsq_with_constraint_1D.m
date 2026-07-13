%% Constrained least-squares polynomial fit (1D)
% Author: Ishida, Noguchi, Kyoto Univerity (2024-12-12)
%
% Fits a degree-n polynomial y = f(x) to two-column data (x, y) using:
%   1) Constrained least squares, requiring the fit to be
%      monotonically increasing (dy/dx >= 0) and non-negative (y >= 0)
%   2) Ordinary (unconstrained) least squares, for comparison
%
% The two fits are plotted together and compared using the
% Akaike Information Criterion (AIC).
%
% Requires the Optimization Toolbox (for lsqlin).

% If you use this code, **please cite** the following paper:

% > N. Ishida, K. Furuta, M. Kishimoto, T. Sasaki, H. Iwai, K. Izui and S. Nishiwaki:
% > "Data-driven topology optimization of all-solid-state batteries considering conductive
% > additive material informed by microstructure analysis", *Structural and Multidisciplinary
% > Optimization*, 68 (2025), 164.
% > doi: [10.1007/s00158-025-04094-9](https://doi.org/10.1007/s00158-025-04094-9)

clear;
addpath("function/");

%% Settings
data_file = 'input.dat';   % two-column data file: [x, y]
n = 4;                     % polynomial degree

%% Load data
data = readmatrix(data_file);
x_data = data(:, 1);
y_data = data(:, 2);

%% Constrained least squares
% C * a ~= y_data, subject to:
%   dy/dx >= 0  (monotonically increasing)  ->  A1 * a <= 0
%   y     >= 0  (non-negative)              -> -C  * a <= 0
C  = createPolynomialMatrix1D(x_data, n);
A1 = createPolynomialMatrix1D_dx(x_data, n);
A  = [A1; -C];
b  = zeros(2 * length(x_data), 1);

a = lsqlin(C, y_data, A, b);

%% Ordinary least squares (no constraints), for comparison
coeff = C \ y_data;  % coeff = [a0, a1, ..., an]

%% Plot: data and both fitted curves
figure;
scatter(x_data, y_data, 'filled');
hold on;

x_fit = linspace(min(x_data), max(x_data), 1000);
y_fit_constrained   = evaluatePolynomial1D(a, x_fit, n);
y_fit_unconstrained = evaluatePolynomial1D(coeff, x_fit, n);

plot(x_fit, y_fit_constrained,   'r-', 'LineWidth', 2);
plot(x_fit, y_fit_unconstrained, 'g-', 'LineWidth', 2);

xlabel('x');
ylabel('y');
title('Scatter Plot and Polynomial Fit');
legend('Data', 'LS with constraint', 'Ordinary LS', 'Location', 'northwest');
grid on;
hold off;

exportgraphics(gcf, 'output.png');

%% Model comparison: Akaike Information Criterion (AIC)
% AIC = 2*k + N*log(RSS/N)
%   k:   number of fitted parameters
%   N:   number of data points
%   RSS: residual sum of squares (using the constrained fit)
Y_pred = evaluatePolynomial1D(a, x_data, n);
RSS = sum((y_data - Y_pred).^2);

num_data   = length(y_data);
num_params = length(a);

AIC = 2 * num_params + num_data * log(RSS / num_data);

fprintf('n = %d\n', n);
fprintf('AIC: %.4f\n', AIC);

%% Print fitted polynomials as strings
poly_str_constrained   = createPolynomialString(a, n);
poly_str_unconstrained = createPolynomialString(coeff, n);

disp('With constraint:');
disp(poly_str_constrained);
disp('Without constraint:');
disp(poly_str_unconstrained);
