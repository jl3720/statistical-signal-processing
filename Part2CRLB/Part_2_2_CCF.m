%% 2.2
% clc; clear all; close all;
x = randn(1000,1);  % WGN
y = filter(ones(9,1), [1], x);
[rxy, lags] = xcorr(x,y,'unbiased');
figure(2); stem(lags, rxy)
title('CCF for input and output of MA filter')
xlabel('Correlation lag, \tau')
ylabel('Cross Correlation')
xlim([-20,20])
