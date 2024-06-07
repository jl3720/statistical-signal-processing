% 4.4 Identification of AR Process

% Generate true AR process
eta = randn(1000,1);
a = [1, 0.9, 0.2];
b = [1];

x_ = filter(b,a,eta);  % True AR process realisation
% x = x_./std(x_);
x = zscore(x_);

%% Get LSE
p = 2;  % AR Order
mu = 0.01;
[xhat, err, weights] = lmsAR(x, mu, p);
figure(1); clf;

subplot(1,2,1); hold on; grid on;
% plot(weights(1,:)*sqrt(a*a'),'b')
% plot(weights(2,:)*sqrt(a*a'),'r')
plot(weights(1,:)*sqrt(a*a'),'b')
plot(weights(2,:)*sqrt(a*a'),'r')

% coefs = [-0.9 -0.2];
% bounds = 0.2 * coefs;
% yline([coefs+bounds, coefs-bounds], 'r--')

title('Time evolution of the estimated filter coefficients for \mu=0.01')
xlabel('Sample number')
ylabel('Adaptive weight values, \bf w[n]')
legend('w_{1}','w_{2}','+/-20%', 'orientation','horizontal')

subplot(1,2,2);
gaus = gausswin(10, 1.5);
gaus = gaus/sum(gaus);
plot(filter(gaus, 1,err.^2)); grid on;
title('Time evolution for the squared estimation error for \mu=0.01')
xlabel('Sample number')
ylabel('Squared estimation error')

%% 4.4 Varying gain
mus = [0.003, 0.01, 0.2];
close all;
figure(1); clf;
t = tiledlayout(3,2);
title(t, 'Time evolution of coefficients and squared error for varying gain')
for mu=mus
    [yhat, err, weights] = lmsAR(x, mu, 2);
    nexttile; hold on; grid on;
    plot(weights(1,:)*sqrt(a*a'),'b')
    plot(weights(2,:)*sqrt(a*a'),'r')
    title(strcat('\mu=', num2str(mu)))
    xlabel('Sample number')
    ylabel('Adaptive weights, \bf w[n]')
%     legend('w_{0}','w_{1}','w_{2}','w_{3}','w_{4}', 'orientation','horizontal')
    ylim([-2 1])
    
    nexttile;
    gaus = gausswin(10, 1.5);
    gaus = gaus/sum(gaus);
    plot(filter(gaus, 1,err.^2)); grid on;
    title(strcat('\mu=', num2str(mu)))
    xlabel('Sample number')
    ylabel('Squared estimation error')
    xlim([12 1000])
end