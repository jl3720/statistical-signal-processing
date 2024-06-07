% 1.3 Bias of sample mean

% Initialise matrix
x = zeros(10,1000);

% Generate ten 1000-sample realisations of X
for i=1:10
    x(i,:) = rand(1,1000);
end

% Calculate means and standard deviations
m_hat = mean(x, 2)
sigma_hat = std(x, 0, 2)

% Plot Estimates
fig1 = figure(1);
clf

subplot(2,1,1); hold on;
plot(m_hat, 'x');
yline(0.5);
title('Plot of sample means', 'Interpreter', 'Latex');
legend('Sample mean','Theoretical mean', 'Interpreter', 'Latex')
xlabel('Ensemble index')
ylabel('Sample mean, \^{m} (AU)')
ylim([0 1])
hold off;

subplot(2,1,2); hold on;
plot(sigma_hat, 'x');
yline(1/sqrt(12));
title('Plot of sample standard deviations');
legend('Sample standard deviation', 'Theoretical standard deviation')
xlabel('Ensemble index')
ylabel('Sample standard deviation, $\hat{\sigma}$ (AU)')
ylim([0 0.5])
hold off;
