%% 2.1.1 and 2.1.2
x = randn(1000,1);  % WGN
[c, lags] = xcorr(x, 'unbiased');
figure(1);
plot(lags, c)
title('ACF for 1000-sample realisation of White Gaussian Noise')
xlabel('Autocorrelation lag, \tau')
ylabel('Autocorrelation')
% xlim([-50, 50])

%% 2.1.4
y = filter(ones(9,1), [1], x);
[yc, ylags] = xcorr(y, 'unbiased');
figure(2); stem(ylags, yc)
title('ACF for MA(9) Process')
xlabel('Autocorrelation lag, \tau')
ylabel('Autocorrelation')
xlim([-20,20])
