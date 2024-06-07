load sunspot.dat

x_full = sunspot(:,2);

[r_5, lags_5] = xcorr(x_full(1:5), 'unbiased');
[r_20, lags_20] = xcorr(x_full(1:20), 'unbiased');
[r_250, lags_250] = xcorr(x_full(1:250), 'unbiased');

figure(1); 

subplot(3,1,1);
stem(lags_5, r_5);
title('ACF for N=5')
xlabel('Autocorrelation lag, \tau')
ylabel('Autocorrelation, R[\tau]')

subplot(3,1,2)
stem(lags_20, r_20);
title('ACF for N=20')
xlabel('Autocorrelation lag, \tau')
ylabel('Autocorrelation, R[\tau]')

subplot(3,1,3)
plot(lags_250, r_250);
title('ACF for N=250')
xlabel('Autocorrelation lag, \tau')
ylabel('Autocorrelation, R[\tau]')

disp(mean(x_full(1:5)))
disp(mean(x_full(1:20)))
disp(mean(x_full(1:250)))

% zero mean version
figure(2)
N = 5;
s3 = x_full(1:N);
[r_0, lags_0] = xcorr(s3-mean(s3), 'unbiased');
subplot(3,1,1);
stem(lags_0, r_0);
title("ACF for N=" + N)
xlabel('Autocorrelation lag, \tau')
ylabel('Autocorrelation, R[\tau]')

N = 20;
s3 = x_full(1:N);
[r_0, lags_0] = xcorr(s3-mean(s3), 'unbiased');
subplot(3,1,2);stem(lags_0, r_0);
title("ACF for N=" + N)
xlabel('Autocorrelation lag, \tau')
ylabel('Autocorrelation, R[\tau]')

N = 250;
s3 = x_full(1:N);
[r_0, lags_0] = xcorr(s3-mean(s3), 'unbiased');
subplot(3,1,3);plot(lags_0, r_0);
title("ACF for N=" + N)
xlabel('Autocorrelation lag, \tau')
ylabel('Autocorrelation, R[\tau]')

figure(3); clf;
N = 250;
s3 = x_full(1:N);
[r_0, lags_0] = xcorr(s3-mean(s3), 'unbiased');
plot(lags_0, r_0);
title("ACF for N=" + N)
xlabel('Autocorrelation lag, \tau')
ylabel('Autocorrelation, R[\tau]')

figure(4); clf
N = 20;
s3 = x_full(1:N);
[r_0, lags_0] = xcorr(s3-mean(s3), 'unbiased');
plot(lags_0, r_0);
title("ACF for N=" + N)
xlabel('Autocorrelation lag, \tau')
ylabel('Autocorrelation, R[\tau]')
% 
% figure(4)
% autocorr(x_full(1:201), NumLags=200)
