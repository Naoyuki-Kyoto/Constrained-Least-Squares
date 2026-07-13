%% Constrained least-squares polynomial surface fit (2D)
% Author: Ishida, Noguchi (2024-12-09)
%
% Fits a polynomial surface z = f(x, y) (degree n in x, degree m in y)
% to three-column data (x, y, z) using:
%   1) Constrained least squares, requiring the fit to be
%      monotonically increasing in x (dz/dx >= 0),
%      monotonically increasing in y (dz/dy >= 0), and non-negative (z >= 0)
%   2) Ordinary (unconstrained) least squares, for comparison
%
% Both fits are plotted as surfaces and compared using the
% Akaike Information Criterion (AIC).
%
% Requires the Optimization Toolbox (for lsqlin).

clear;
addpath("function/");

%% Settings
data_file = 'input.dat';   % three-column data file: [x, y, z]
n = 2;                     % polynomial degree in x
m = 3;                     % polynomial degree in y

%% Load data
data = readmatrix(data_file);
data_x = data(:, 1);
data_y = data(:, 2);
data_z = data(:, 3);

%% Constrained least squares
% C * a ~= data_z, subject to:
%   dz/dx >= 0  (monotonically increasing in x)  -> A1 * a <= 0
%   dz/dy >= 0  (monotonically increasing in y)  -> A2 * a <= 0
%   z     >= 0  (non-negative)                   -> -C * a <= 0
C  = createPolynomialMatrix(data_x, data_y, n, m);
A1 = createPolynomialMatrix_dx(data_x, data_y, n, m);
A2 = createPolynomialMatrix_dy(data_x, data_y, n, m);
F  = [A1; A2; -C];
b  = zeros(3 * length(data_x), 1);

a = lsqlin(C, data_z, F, b);

%% Ordinary least squares (no constraints), for comparison
coeff = C \ data_z;  % coeff = [a00, a01, ..., a0m, a10, a11, ..., anm]

%% Fitted surfaces (evaluated on a grid for plotting)
[X_fit, Y_fit] = meshgrid(linspace(min(data_x), max(data_x), 50), ...
                           linspace(min(data_y), max(data_y), 50));
Z_fit_constrained   = evaluatePolynomial(a,     X_fit, Y_fit, n, m);
Z_fit_unconstrained = evaluatePolynomial(coeff, X_fit, Y_fit, n, m);

%% Plot: constrained fit
figure(1);
h = surf(X_fit, Y_fit, Z_fit_constrained);
alpha(h, 0.5);  % surface transparency (0: fully transparent, 1: opaque)
hold on;

scatter3(data_x, data_y, data_z, 80, 'k', 'filled');  % data points, black outline
scatter3(data_x, data_y, data_z, 30, 'w', 'filled');  % data points, white fill

xlabel('x');
ylabel('y');
zlabel('z');
title('Least squares with constraint');
grid on;
hold off;

exportgraphics(figure(1), 'output_with_constraint.png');

%% Plot: unconstrained fit
figure(2);
h2 = surf(X_fit, Y_fit, Z_fit_unconstrained);
alpha(h2, 0.5);
hold on;

scatter3(data_x, data_y, data_z, 'r', 'filled');

xlabel('x');
ylabel('y');
zlabel('z');
title('Least squares without constraint');
grid on;
hold off;

exportgraphics(figure(2), 'output_without_constraint.png');

%% Model comparison: Akaike Information Criterion (AIC)
% AIC = 2*k + N*log(RSS/N)
%   k:   number of fitted parameters
%   N:   number of data points
%   RSS: residual sum of squares (using the constrained fit)
Z_pred = evaluatePolynomial(a, data_x, data_y, n, m);
RSS = sum((data_z - Z_pred).^2);

num_data   = length(data_z);
num_params = length(a);

AIC = 2 * num_params + num_data * log(RSS / num_data);

fprintf('n = %d, m = %d\n', n, m);
fprintf('AIC: %.4f\n', AIC);

%% Print fitted polynomials as strings
poly_str_constrained   = createPolynomialString(a, n, m);
poly_str_unconstrained = createPolynomialString(coeff, n, m);

disp('With constraint:');
disp(poly_str_constrained);
disp('Without constraint:');
disp(poly_str_unconstrained);
