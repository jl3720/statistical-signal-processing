% 4.2 Least Mean Square (LMS) Algorithm
x = randn(1000,1);      
b = [1 2 3 2 1];   
a = [1];
y = (filter(b,a,x))/std(filter(b,a,x));           
noise = sqrt(0.1)*randn(1000,1); 
z = y + noise;

%% 4.2.2 mu=0.01
clc;
mu = 0.01;
[yhat, err, weights] = lms(x, z, mu, 4);
figure(1); clf;

subplot(1,2,1); hold on; grid minor;
plot(weights(1,:)*4.3589,'b')
plot(weights(2,:)*4.3589,'r')
plot(weights(3,:)*4.3589,'k')
plot(weights(4,:).*4.3589)
plot(weights(5,:)*4.3589,'g')
coefs = [1 2 3];
bounds = 0.2 * coefs;
yline([coefs+bounds, coefs-bounds], 'r--')

title('Time evolution of the estimated filter coefficients for \mu=0.01')
xlabel('Sample number')
ylabel('Adaptive weight values, \bf w[n]')
legend('w_{0}','w_{1}','w_{2}','w_{3}','w_{4}','+/-20%', 'orientation','horizontal')

subplot(1,2,2);
plot(err.^2); grid on;
title('Time evolution for the squared estimation error for \mu=0.01')
xlabel('Sample number')
ylabel('Squared estimation error')

%% 4.2.3 Varying gain
mus = linspace(0.002, 0.5, 3);
close all;
figure(1); clf;
t = tiledlayout(3,2);
title(t, 'Time evolution of coefficients and squared error for varying gain')
for mu=mus
    [yhat, err, weights] = lms(x, z, mu, 4);
    nexttile; hold on; grid on;
    plot(weights(1,:)*4.3589,'b')
    plot(weights(2,:)*4.3589,'r')
    plot(weights(3,:)*4.3589,'k')
    plot(weights(4,:).*4.3589)
    plot(weights(5,:)*4.3589,'g')
    title(strcat('\mu=', num2str(mu)))
    xlabel('Sample number')
    ylabel('Adaptive weight values, \bf w[n]')
%     legend('w_{0}','w_{1}','w_{2}','w_{3}','w_{4}', 'orientation','horizontal')
    
    nexttile;
    plot(err.^2); grid on;
    title(strcat('\mu=', num2str(mu)))
    xlabel('Sample number')
    ylabel('Squared estimation error')
end

%% 4.3 Gear shifting
rng(1, 'twister');
mu = 0.002;
[yhat, err, weights] = gear_shift(x, z, mu, 4);
figure(3); clf;
subplot(1,2,1); hold on; grid minor;
plot(weights(1,:).*4.3589,'b')
plot(weights(2,:).*4.3589,'r')
plot(weights(3,:).*4.3589,'k')
plot(weights(4,:).*4.3589)
plot(weights(5,:).*4.3589,'g')

coefs = [1 2 3];
bounds = 0.2 * coefs;
yline([coefs+bounds, coefs-bounds], 'r--')

% plot(weights(1,:)./sqrt(0.1),'b')
% plot(weights(2,:)./sqrt(0.1),'r')
% plot(weights(3,:)./sqrt(0.1),'k')
% plot(weights(4,:)./sqrt(0.1))
% plot(weights(5,:)./sqrt(0.1),'g')

title('Time evolution of the estimated filter coefficients for adaptive gain')
xlabel('Sample number')
ylabel('Adaptive weight values, \bf w[n]')
legend('w_{0}','w_{1}','w_{2}','w_{3}','w_{4}','+/-20%', 'orientation','horizontal')

subplot(1,2,2);
plot(err.^2); grid on;
title('Time evolution for the squared estimation error for adaptive gain')
xlabel('Sample number')
ylabel('Squared estimation error')

