% 3.5 Realworld signals: Respiratory arrhythmia from RR-Intervals
load RRI_data.mat;
load RRI_freq.mat;
%% Trial One
[p, f] = pgm(RRIP1T3);  % Standard periodogram

% 50s window
L = length(RRIP1T3);
winL = 50;
win = winL * f1;  % Window length (s) * sampling freq = Num samps
numWins = floor(L/win);
prdgms = zeros(numWins, win/2);
for i=0:(numWins-1)
    section = RRIP1T3(i*win+1:(i+1)*win);  % .* hanning(win).'
    [prdgms(i+1,:), f_avg50] = pgm(section);
end
avg_prdgm50 = mean(prdgms,1);

% 150s window length
winL = 150;
win = winL * f1;  % Window length (s) * sampling freq = Num samps
numWins = floor(L/win);
prdgms = zeros(numWins, win/2);
for i=0:(numWins-1)
    section = RRIP1T3(i*win+1:(i+1)*win);  %.* hanning(win).'
    [prdgms(i+1,:), f_avg150] = pgm(section);
end
avg_prdgm150 = mean(prdgms,1);

% Plot periodograms
figure(1);
t = tiledlayout(3,1);
xlabel(t, 'Normalised frequency, f')
ylabel(t, 'PSD (dB)')
title(t, 'Trial 3')

nexttile;
plot(f, 20*log10(p))
xlim([0 0.5]); title('Standard periodogram');
grid minor;

nexttile;
plot(f_avg50, 20*log10(avg_prdgm50))
xlim([0 0.5]); title('Averaged periodogram (Rectangular window length of 50s)')
grid minor;

nexttile;
plot(f_avg150, 20*log10(avg_prdgm150))
xlim([0 0.5]); title('Averaged periodogram (Rectangular window length of 150s)')
grid minor;

%% Test built in
nexttile;
winL = 20;
win = winL * f1;  % Window length (s) * sampling freq = Num samps
numWins = floor(L/win);
prdgms = []

for i=0:(numWins-1)
    [prdgms(i+1,:), fxx] = periodogram(RRIP1T3(i*win+1:(i+1)*win), hanning(win).', [], f1);
end
avg_periodogram = mean(prdgms,1);

plot(fxx, 20*log10(avg_periodogram))
ylim([-120 60])
