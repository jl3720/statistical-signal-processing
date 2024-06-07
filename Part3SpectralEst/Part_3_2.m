%% 3.2 Spectrum of autoregressive processes

x = randn(1064,1);  % WGN

b= [1];
a = [1 0.9];

y_unf = filter(b,a, x);  % Generate AR(1) process
y = y_unf(40:end);

% Plot x and y in time domain
figure(1);
t= tiledlayout(2,1);

nexttile;
plot(x); grid on;
xlabel('Sample number, n')
ylabel('Signal value, x[n]')
title('Plot of x[n], WGN in time domain')
xlim([0 1050])

nexttile(t);
plot(y); grid on;
xlabel('Sample number, n')
ylabel('Signal value, y[n]')
title('Plot of y[n], AR(1) realisation in time domain')
xlim([0 1050])

%% 3.2.1
[h,w] = freqz(b, a, 512);  % Get Transfer Function
figure(3); clf;
plot(w/2/pi, 20*log10(abs(h).^2));  % Plot Theoretical PSD
title('Theoretical PSD of AR(1) Process')
xlabel('Normalised frequency, f')
ylabel('PSD (dB)')
grid minor;
% set(gca, 'YScale', 'log')

figure(4); clf;
[ACF, lags] = xcorr(y, 'unbiased');
stem(lags(ismember(lags, 1:20)), ACF(ismember(lags, 1:20)))
xlabel('Autocorrelation lag, \tau')
ylabel('ACF')
title('ACF for realisation of AR(1) process')

%% 3.2.2 Periodogram
figure(3); hold on;
[Pyy, w] = pgm(y);
plot(w/2/pi, 20*log10(Pyy), 'r')
legend('Theoretical PSD', 'Periodogram Estimate')
title('PSD Estimates of AR(1) Process')
%% 3.2.3 Zoom
xlim([0.4 0.5])

%% 3.2.4 Estimate coefficients and model PSD
[Ry, lags] = xcorr(y, 'unbiased');

Ry0 = Ry(lags==0);
Ry1 = Ry(lags==1);

a_hat = -Ry1/Ry0;
var_hat = Ry0 + a_hat*Ry1;

b = 1;
a = [1 a_hat];  % Set AR(1) coefficients for transfer func

[H, w] = freqz(b,a, 1025);  % Return same size as Pyy
Py = abs(H).^2 .*var_hat;  % Py = H squared * Px

figure(4); clf; hold on;
plot(w/2/pi, 20*log10(Py));  % Plot Model-Based PSD w/ dB scale
plot(w/2/pi, 20*log10(Pyy), 'r')  % Plot Periodogram
legend('Model-Based PSD', 'Periodogram Estimate')

title('Model-Based PSD and Periodogram of AR(1) Process')
xlabel('Normalised frequency, f')
ylabel('PSD (dB)')
grid minor;

%% 3.2.5 Sunspot Series Spectrum Modelling
clc; close all;
% Load data
load sunspot.dat
x = sunspot(:,2);
x0 = detrend(x); 

% Get AR coefficient estimates from YW
P = [1 2 10];  % Store model orders

figure(1);
t = tiledlayout(3,2);
title(t, "Model-Based and Periodogram PSD Estimates");
ylabel(t, "PSD (dB)")
xlabel(t, "Normalised frequency, f")
for p=P
    % Plot standard series
    nexttile; hold on;
    [a, v] = aryule(x,p);  % Standard series
    [a0, v0] = aryule(x0,p);  % Detrended series
    
    [H,w] = freqz(1,a, 257);
    P_model = abs(H).^2 .* v;  % Calculate model-based PSD
    
    plot(w/2/pi, 20*log10(P_model));  % Plot model based PSD of standard
    [prdgm,f] = pgm2(x);  % Plot periodogram of standard
    plot(f, 20*log10(prdgm));
    title(sprintf('Model Order: %i', p))
    legend('Model-Based PSD', 'Periodogram')
    
    % Plot detrended
    nexttile; hold on;
    [H0,w0] = freqz(1,a0, 257);
    P_model0 = abs(H0).^2 .* v0;  % Calculate model-based PSD
    
    plot(w0/2/pi, 20*log10(P_model0));  % Plot model based PSD of standard
    [prdgm0,f] = pgm2(x0);  % Plot periodogram of standard
    plot(f, 20*log10(prdgm0));
    ylim([-50 150]);
    title(sprintf('Model Order: %i', p))
    legend('Model-Based PSD', 'Periodogram')
end

