% 3.4 Spectogram for time-frequency analysis: dial tone pad

%% 3.4.1 Random Landline
rng(1, "twister");  % To reproduce random landline number
number = [0, 2, 0, randi([0 9], [1, 8])];

myKeys = [0:9];
myValues = {[941,1336],[697,1209],[697,1336],[697,1477],[770,1209],[770,1336],[770,1477],[852,1209],[852,1336],[852,1477]};
ftable = dictionary(myKeys, myValues);

fs = 32768;  % Sampling frequency
T = 1/fs;  % Sampling period

y = [0];  % Initialise signal


for i=number
    t = T:T:0.25;  % 0.25s at sampling freq=32768 Hz
    % Look up frequencies
    freqs = ftable(i);
    f1 = freqs{1}(1);
    f2 = freqs{1}(2);
    
    % Generate signal segment
    sig = sin(2*pi*f1.*t) + sin(2*pi*f2.*t);
    idle = zeros(size(t));
    seg = [sig, idle];

    % Add segment to y
    y = [y, seg];
end
y = y(1:end-length(t));
tt = 0:T:5.25;
figure(1); clf;
plot(tt, y(1:length(tt)));
xlabel('Time (seconds)'); ylabel('Signal (AU)')
%% Digit 2
xlim([0.5 0.5+15*1/1000]);
title('Two-tone signal for the digit 2 within the DTMF system')

%% Digit 4
xlim([1.5 1.5+15*1/1000])
title('Two-tone signal for the digit 4 within the DTMF system')

%% Idle
xlim([0.25 0.25+15*1/1000])
title('Idle section of signal')

%% 3.4.2 Spectrogram
figure(2); clf;
N = length(y);
win_L = floor(N/21);  % Generate window to select 1/21 of signal
spectrogram(y, hamming(win_L), 0, win_L, fs, "yaxis");
[s,f,t] = spectrogram(y, hamming(win_L), 0, win_L, fs, "yaxis");

ylim([0 1.8])
title('Spectrogram for two-tone DTMF signal')

figure(3); clf; hold on
plot(f, 20*log10(abs(s(:,3)).^2/N), 'DisplayName', 'Digit 2')
plot(f, 20*log10(abs(s(:,7)).^2/N), 'DisplayName', 'Digit 4')
legend('show')
xlim([0 2000]); grid on;
title('Power spectrum estimate for Digit 2 and Digit 4')
xlabel('Frequency (Hz)'); ylabel('PSD (dB)')

%% 3.4.4 Corruption with channel noise
A = 2;  % Amplitude of sinusoid
SNR = [0.5, 1, 10];  % Different signal to noise ratios SNR = A^2 / 2 var

% High variance noise
V = A^2/2/SNR(1);
noise = randn(size(y)).*sqrt(V);
y_high = y + noise;

% Medium variance
V = A^2/2/SNR(2);
noise = randn(size(y)).*sqrt(V);
y_med = y + noise;

% Low variance
V = A^2/2/SNR(3);
noise = randn(size(y)).*sqrt(V);
y_low = y + noise;

figure(4); clf;
t = tiledlayout(4,1);
title(t, 'Two-tone signal corrupted by varying amounts of noise')
xlabel(t, 'Time (s)'); ylabel(t, 'Signal (AU)')

nexttile;
plot(tt, y);  title('Original Signal');
xlim([0.24 0.26])

nexttile;
plot(tt, y_low); title('Low variance noise')
xlim([0.24 0.26])

nexttile;
plot(tt, y_med); title('Medium variance noise')
xlim([0.24 0.26])

nexttile;
plot(tt, y_high); title('High variance noise')
xlim([0.24 0.26]); ylim([-5 5])

%% Plot spectrograms
figure(1); clf;
t = tiledlayout(1,3);
title(t, 'Spectrograms of two-tone signal for varying levels of noise')

nexttile;
spectrogram(y_low, hamming(win_L), 0, win_L, fs, "yaxis");  % Low noise
title('Low variance noise'); ylim([0.4 1.8]);

nexttile;
spectrogram(y_med, hamming(win_L), 0, win_L, fs, "yaxis");  % Med noise
ylim([0.4 1.8]); title('Medium variance noise');

nexttile;
spectrogram(y_high, hamming(win_L), 0, win_L, fs, "yaxis");  % High noise
ylim([0.4 1.8]); title('High variance noise');

%% Check
figure(2);
n = 0:1/32768:0.25;
freqs = ftable(4);
f1 = freqs{1}(1);
f2 = freqs{1}(2);
y = sin(2*pi*f1.*n) + sin(2*pi*f2.*n);
plot(n,y)
xlim([0 0.015])

