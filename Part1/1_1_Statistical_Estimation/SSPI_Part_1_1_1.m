% 1.1 Theoretical and sample mean

% Plot x[n] realisations
clf;
x = rand(1000,1);
fig1 = figure(1); hold on;
boxplot(x); title('Display of $X_{n}$, a stationary stochastic process', 'Interpreter', 'Latex');
s = scatter(ones(size(x)), x, 'filled');
alpha(s, 0.15);
legend('x[n], realisation of stochastic process');
xticks([]); ylabel('Value of x[n] (AU)')
set(gca, 'YAxisLocation', 'origin')
xlim([0.5 1.5])
hold off;

% Calculate theoretical mean
m_theoretical = 1/2  % Integral of 1*x from 0 to 1

% Calculate sample mean
N = 1000;
m_sample = mean(x)

error = abs(m_sample-m_theoretical)/m_theoretical  % unbiased estimator, but variance



