% Gaussian Random Variable

%% 1.5.1 and 1.5.2 Theoretical mean and std

x = randn([1000 1]);
mhat = mean(x)
sigma_hat = std(x)

%% 1.5.3 Bias

% Initialise matrix
x_vec = zeros(10,1000);

% Generate ten 1000-sample realisations of X
for i=1:10
    x_vec(i,:) = randn(1,1000);
end

% Calculate means and standard deviations
m_hat_vec = mean(x_vec, 2)
sigma_hat_vec = std(x_vec, 0, 2)

% Plot Estimates
fig1 = figure(1);
clf

subplot(2,1,1); hold on;
plot(m_hat_vec, 'x');
yline(0);
title('Plot of sample means', 'Interpreter', 'Latex');
legend('Sample mean','Theoretical mean', 'Interpreter', 'Latex')
xlabel('Ensemble index')
ylabel('Sample mean, \^{m} (AU)')
ylim([-0.5 0.5])
hold off;

subplot(2,1,2); hold on;
plot(sigma_hat_vec, 'x');
yline(1);
title('Plot of sample standard deviations');
legend('Sample std', 'Theoretical std')
xlabel('Ensemble index')
ylabel('Sample standard deviation, $\hat{\sigma}$ (AU)')
ylim([0.5 1.5])
hold off;

%% 1.1.4 Approximating the pdf

% Generate x
x = randn(1000,1);

figure(1); clf; hold on;
% Approximate pdf
N_BINS = 200;
h = histogram(x, N_BINS, 'Normalization','pdf');

% Theoretical pdf
pd1 = makedist('Normal');  % Standard uniform dist
n = linspace(min(x), max(x), 1000);  % Values to compute theoretical pdf at
pdf1 = pdf(pd1, n);
plot(n, pdf1, 'LineWidth', 0.9)
hold off;

% Format
alpha(h, 0.35);
title('Approximate and Theoretical PDFs for X')
legend('Histogram of \textbf{x}', 'Theoretical uniform pdf')
xlabel('x[n] value')
ylabel('Probability Density')


