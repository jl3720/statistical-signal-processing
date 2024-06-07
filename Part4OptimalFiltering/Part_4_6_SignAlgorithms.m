% 4.6 Sign algorithms
clear all; clc; close all;
% Generate true AR process
eta = randn(1000,1);
a = [1, 0.9, 0.2];
b = [1];

x_ = filter(b,a,eta);  % True AR process realisation
x = x_./std(x_);
% x = zscore(x_);

%% AR parameter ID
p = 2;  % AR Order
mu = 0.01;
[xhat, err, weights_OG] = lmsAR(x, mu, p);
[xhat, err, weights_SE] = lmsSignError(x, mu, p);
[xhat, err, weights_SR] = lmsSignRegressor(x, mu, p);
[xhat, err, weights_SS] = lmsSignSign(x, mu, p);

%% Plots
figure(1); clf;
t = tiledlayout(2,2);

nexttile;hold on; grid minor;
plot(weights_OG(1,:)*sqrt(a*a'),'b')
plot(weights_OG(2,:)*sqrt(a*a'),'r')
title('Original Algorithm')
legend('w_{1}','w_{2}', 'orientation', 'horizontal')

nexttile;hold on; grid minor;
plot(weights_SE(1,:)*sqrt(a*a'),'b')
plot(weights_SE(2,:)*sqrt(a*a'),'r')
title('Signed-Error Algorithm')
legend('w_{1}','w_{2}', 'orientation', 'horizontal')

nexttile;hold on;
plot(weights_SR(1,:)*sqrt(a*a'),'b')
plot(weights_SR(2,:)*sqrt(a*a'),'r')
title('Signed-Regressor Algorithm')
legend('w_{1}','w_{2}', 'orientation', 'horizontal')
grid minor;

nexttile;hold on; grid minor;
plot(weights_SS(1,:)*sqrt(a*a'),'b')
plot(weights_SS(2,:)*sqrt(a*a'),'r')
title('Sign-Sign Algorithm')
legend('w_{1}','w_{2}', 'orientation', 'horizontal')

% coefs = [-0.9 -0.2];
% bounds = 0.2 * coefs;
% yline([coefs+bounds, coefs-bounds], 'r--')

title(t, 'Time evolution of estimated coefficients')
xlabel(t, 'Sample number')
ylabel(t, 'Adaptive weight values, \bf w[n]')

%% Speech recognition
load("e_seg.mat")

% Get LSE for pth order predictor
p = 2;
mu = 0.1;
x = e_seg;  % Order 7 model using "e" segment

[xhat, err, weightsOG] = lmsAR(x, mu, p);
[xhatSE, err, weightsSE] = lmsSignError(x, mu, p);
[xhatSR, err, weightsSR] = lmsSignRegressor(x, mu, p);
[xhatSS, err, weightsSS] = lmsSignSign(x, mu, p);

%% Plots
% [xhat, err, weightsOG_] = lmsAR(x, mu, p);
% [xhatSE, err, weightsSE_] = lmsSignError(x, mu, p);
% [xhatSR, err, weightsSR_] = lmsSignRegressor(x, mu, p);
% [xhatSS, err, weightsSS_] = lmsSignSign(x, mu, p);
% 
% weightsOG = zscore(weightsOG_);
% weightsSE = zscore(weightsSE_);
% weightsSR = zscore(weightsSR_);
% weightsSS = zscore(weightsSS_);

figure(1); clf;
t= tiledlayout(2,2);
title(t, 'Time evolution of the estimated coefficients using Sign Algorithms')
xlabel(t, 'Sample number')
ylabel(t, 'Adaptive weight values, \bf w[n]')

nexttile; hold on; grid minor;

plot(weightsOG(1,:))
plot(weightsOG(2,:))
plot(weightsOG(3,:))
plot(weightsOG(4,:))
plot(weightsOG(5,:))
plot(weightsOG(6,:))
plot(weightsOG(7,:))

title("Original LMS algorithm")

nexttile; hold on; grid minor;
plot(weightsSE(1,:))
plot(weightsSE(2,:))
plot(weightsSE(3,:))
plot(weightsSE(4,:))
plot(weightsSE(5,:))
plot(weightsSE(6,:))
plot(weightsSE(7,:))

title("Signed-Error")

nexttile; hold on; grid minor;
plot(weightsSR(1,:))
plot(weightsSR(2,:))
plot(weightsSR(3,:))
plot(weightsSR(4,:))
plot(weightsSR(5,:))
plot(weightsSR(6,:))
plot(weightsSR(7,:))

title("Signed-Regressor")

nexttile; hold on; grid minor;
plot(weightsSS(1,:))
plot(weightsSS(2,:))
plot(weightsSS(3,:))
plot(weightsSS(4,:))
plot(weightsSS(5,:))
plot(weightsSS(6,:))
plot(weightsSS(7,:))

title("Sign-Sign")

figure(2); clf; hold on; grid minor;

plot(xhat)
plot(e_seg)
legend('Prediction', 'Recorded voice signal')
title('Signed-Predictor predictions for predictor order 7')

%% Generate Rps
% xhat_correct = xhat./std(xhat).*std(seg);
err_var = [];
err_var(1) = var(e_seg - xhat');
err_var(2) = var(e_seg - xhatSE');
err_var(3) = var(e_seg - xhatSR');
err_var(4) = var(e_seg - xhatSS');

input_var = var(e_seg);

Rp = 10*log10(input_var ./ err_var);

