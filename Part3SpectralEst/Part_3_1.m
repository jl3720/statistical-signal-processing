% 3.0 Test pgm

x1 = randn(128, 1);
x2 = randn(256, 1);
x3 = randn(512, 1);

[P1, w1] = pgm(x1);
[P2, w2] = pgm(x2);
[P3, w3] = pgm(x3);

figure(1);
t = tiledlayout(1,3);
title(t, 'pgm function Periodograms for varying data length')
xlabel(t, 'Normalised frequency, f')
ylabel(t, 'Periodogram (dB)')
nexttile;
plot(w1, 20*log10(P1))
nexttile;
plot(w2, 20*log10(P2))
nexttile
plot(w3, 20*log10(P3))
%% 3.1 Averaged periodogram estimates
clc;

b = 0.2*[1 1 1 1 1];  % Denominator TF coefficients
a = 1;  % Numerator TF coefficients
fP1 = filter(b,a, P1);  % Check why not centered around 1
fP2 = filter(b,a, P2);
fP3 = filter(b,a, P3);

figure(3);
t = tiledlayout(1,3);
title(t, 'Periodograms after smoothing with MA filter')
xlabel(t, 'Normalised Frequency, f')
ylabel(t, 'PSD Estimate')
nexttile;
plot(w1/2/pi, fP1)
legend('N=128')

nexttile;
plot(w2/2/pi, fP2)
legend('N=256')

nexttile;
plot(w3/2/pi, fP3)
legend('N=512')

%% 3.1.2 PSD estimates for segments
clc;

WGN = randn(1024,1);
realisations = reshape(WGN, [8, 128]);
size(realisations)
periodograms = zeros(8, 128+1);
frequencies = zeros(8,128+1);

figure(1); clf; hold on; grid on;
for i=1:8
    [periodograms(i,:), frequencies(i,:)] = pgm(realisations(i,:));
    plot(frequencies(i,:), periodograms(i,:), 'DisplayName', num2str(i))  % Note wants subplots if showing
end
legend('show')

figure(2); clf;
k=3;
plot(frequencies(k,:), periodograms(k,:))
% Large variation in PSD estimates

%% 3.1.3 Averaged Periodogram

avg_P = mean(periodograms, 1);
figure(2); clf; grid on;
plot(frequencies(1,:)/2/pi, avg_P)
title('Averaged Periodogram')
ylabel('PSD Estimate')
xlabel('Normalised frequency, f')  % Check why std so low / not centered at 1

