clc;
% Hear Rate Probability Density Estimate 

%% Read in ECG Data
P1 = readmatrix('ecg_s2.csv');

figure(1);
plot(P1(:,3));
grid minor;

ECG_P1T1 = P1(30000:120000, 3);
ECG_P1T2 = P1(170000:240000, 3);
ECG_P1T3 = P1(290000:370000, 3);

%% Plot sections
figure();
plot(ECG_P1T1)
figure()
plot(ECG_P1T2)
figure()
plot(ECG_P1T3)
%% Convert to ECG
close all;
[RRIP1T1, f1] = ECG_to_RRI(ECG_P1T1, 500);  % Sampling frequency of ECG = 500 Hz
[RRIP1T2, f2] = ECG_to_RRI(ECG_P1T2, 500);
[RRIP1T3, f3] = ECG_to_RRI(ECG_P1T3, 500);

%%
figure();
plot(RRIP1T3)
% figure(3); plot(RRIP1T1)
% figure(3);
% subplot(3,1,1)
% plot(ECG_P1T1)
% 
% subplot(3,1,2)
% plot(ECG_P1T2)
% 
% subplot(3,1,3)
% plot(ECG_P1T3)

%% Estimate heart rates
h_11 = 60 ./ RRIP1T1;
N = length(h_11);
alpha = 1;

h_avg_1 = zeros(1, floor(N/10)-1);
for j=0:N/10-1
    h_avg_1(j+1) = alpha*mean(h_11(j*10+1:(j+1)*10));
end

figure(11); clf;
subplot(2,1,1); plot(h_11); ylim([0 85])
subplot(2,1,2); plot(h_avg_1); ylim([0 85])


alpha = 0.6;
h_avg_06 = zeros(1, floor(N/10)-1);
for j=0:N/10-1
    h_avg_06(j+1) = alpha*mean(h_11(j*10+1:(j+1)*10));
end
figure(12); clf;
subplot(2,1,1); plot(h_11); ylim([0 85])
subplot(2,1,2); plot(h_avg_06); ylim([0 85])

%% Plot PDF Estimates
% Raw Heart Rates
figure(11);
t = tiledlayout(3,1);
title(t, 'PDEs for original and averaged heart rates')
xlabel(t, 'Heart rate (bpm)')
ylabel(t, 'Probability density')

N_bins = 25;
nexttile;
histogram(h_11, N_bins, 'Normalization','pdf')
xlim([0,80]); title('Original heart rates')

% Averaged, alpha = 0.6
nexttile;
histogram(h_avg_06, N_bins, 'Normalization','pdf')
xlim([0,80]); title('Averaged heart rates (\alpha = 0.6)')

% Averaged, alpha=1
nexttile;
histogram(h_avg_1, N_bins, 'Normalization','pdf')
xlim([0,80]); title('Averaged heart rates (\alpha = 1)')

%% AR Modelling of heart rate
% Autocorrelation sequence for RRI data

RRI1 = detrend(RRIP1T1);
RRI2 = detrend(RRIP1T2);
RRI3 = detrend(RRIP1T3);

% Trial 1, Unconstrained Breathing
[r1, lags1] = xcorr(RRI1);
figure(14);
% stem(lags1, r1, 'Marker', 'none')
plot(lags1, r1); grid on;
xlabel('Autocorrelation lag, \tau')
ylabel('ACF')
title('ACF for Trial 1, Unconstrained Breathing')

% Trial 2, Constrained 50 BPM Breathing
[r1, lags1] = xcorr(RRI2);
figure(15);
% stem(lags1, r1, 'Marker', 'none')
plot(lags1, -r1); grid on;
xlabel('Autocorrelation lag, \tau')
ylabel('ACF')
title('ACF for Trial 2, Constrained 50 BPM Breathing')

[r1, lags1] = xcorr(RRI3);
figure(16);
% stem(lags1, r1, 'Marker', 'none')
plot(lags1, r1); grid on;
xlabel('Autocorrelation lag, \tau')
ylabel('ACF')
title('ACF for Trial 3, Constrained 15 BPM Breathing')

%% Optimal AR model order
[rxx1, e, pacs1] = aryule(RRI1,10);
[rxx2, e, pacs2] = aryule(RRI2,10);
[rxx3, e, pacs3] = aryule(RRI3,10);

figure(); 
t = tiledlayout(1,3);
title(t, 'PACF for up to model order 10')
xlabel(t, 'Model order, p')
ylabel(t, 'Correlation Coefficent')

nexttile; hold on;
stem(pacs1);
title('Unconstrained breathing')
N = length(RRI1);
yline(1.96/sqrt(N), 'r--')  % Conf int
yline(-1.96/sqrt(N), 'r--')
legend('PACF Coeffients', '95% Confidence Intervals', 'location','southeast'); grid minor;

nexttile; hold on;
stem(pacs2);
title('Constrained Breathing 50 breaths/min')
N = length(RRI2);
yline(1.96/sqrt(N), 'r--')  % Conf int
yline(-1.96/sqrt(N), 'r--')
legend('PACF Coeffients', '95% Confidence Intervals','location','southeast'); grid minor;

nexttile; hold on;
stem(pacs3);
title('Constrained Breathing 15 breaths/min')
N = length(RRI3);
yline(1.96/sqrt(N), 'r--')  % Conf int
yline(-1.96/sqrt(N), 'r--')
legend('PACF Coeffients', '95% Confidence Intervals', 'location','southeast'); grid minor;