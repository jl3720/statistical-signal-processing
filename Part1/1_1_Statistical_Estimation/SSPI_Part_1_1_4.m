% 1.1.4 Approximating the pdf

% Generate x
x = rand(50000,1);

figure(1); clf; hold on;
% Approximate pdf
N_BINS = 20;
h = histogram(x, N_BINS, 'Normalization','pdf');

% Theoretical pdf
pd1 = makedist('Uniform');  % Standard uniform dist
n = linspace(0, 1, N_BINS);  % Values to compute theoretical pdf at
pdf1 = pdf(pd1, n);
plot(n, pdf1, 'LineWidth', 0.9)
hold off;

% Format
alpha(h, 0.35);
title('Approximate and Theoretical PDFs for X')
legend('Histogram of \textbf{x}', 'Theoretical uniform pdf')
xlabel('x[n] value')
ylabel('Probability Density')
