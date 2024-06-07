% Yule-Walker to calcuate partial correlation
load sunspot.dat
x = sunspot(:,2);
m = mean(x);
s = std(x);
x0 = (x-m)./s;  % Zero mean, unit variance series

P = 10;
AC = zeros(P,P);  % Store AC coefficients
AC0 = zeros(P,P);

for p=1:P
    a_matlab = aryule(x, p);
    a = -a_matlab(2:end);
    AC(p,1:p) = a;

    % Repeat for zero mean, unit var
    a_matlab0 = aryule(x0, p);
    a0 = -a_matlab0(2:end);
    AC0(p,1:p) = a0;
end

PAC = zeros(1,P);
for i=1:P
    PAC(i) = AC(i,i);
end
% Repeat for zero mean, unit var
PAC0 = zeros(1,P);
for i=1:P
    PAC0(i) = AC0(i,i);
end

N = length(x0);
clf; stem(PAC); hold on; stem(PAC0, 'r')
plot(1.96/sqrt(N).*[ones(1,10)], 'k--')
plot(-1.96/sqrt(N).*[ones(1,10)], 'k--')
xlabel('Autocorrelation lag'); ylabel('PCF')
title('Partial ACF up to Order p=10'); grid on;
legend('Raw Sunspot Data', 'Zero Mean Unit Variance', '95% Confidence Intervals')

%% 2.3.4 Model Order Selection (for standardised data)

pred = zeros(size(x0));  % Initialising prediction vector
% pred(1:P) = randn(P,1);  % First 10 values are standard normal rv
% Or initialise to first 10 vals of x0
P = 2;
pred(1:P) = x0(1:P);

for i=11:numel(pred)
    sum = randn(1,1);
    for j=1:P
        sum = sum + AC0(P,j) * pred(i-j);
%         disp(j)
        disp(i-j)
    end
    pred(i) = sum;
end

figure(2); clf; hold on;
plot(pred);
plot(x0)
legend('Predicted', 'Real')

%% Try MATLAB in built

model = arima('AR', AC0(2,:), 'Constant', 0, 'Variance', 0.1)
Y = simulate(model, 300);

figure(5); clf; hold on;
plot(Y)
plot(x0)
xlim([0,300])
title('Simulated AR(2) Process')

%% Try ar function
N = numel(x0);
predictions = zeros(10, N);

for i=1:10
    a = ar(x0, i, 'yw');
    predictions(i,:) = predict(a, x0, 1);
end

% figure(2); clf; hold on; grid minor;
% plot(predicted); plot(x0);
% legend('Predicted', 'Ground Truth')

E = sum((predictions-x0.').^2, 2);  % Am I modelling on training data?
p = [1:10].';
MDL = log(E) + p.*log(N)./N;
AIC = log(E) + 2.*p./N;
AICc = AIC + 2.*p.*(p + 1)./(N-p-1);

figure(3); clf; hold on;
plot(MDL, 'DisplayName', 'MDL')
plot(AIC, 'DisplayName', 'AIC')
plot(AICc, 'DisplayName', 'AICc')
% plot(log(E), 'DisplayName', 'Cumulative Square Error, E')
legend('show'); grid on;
title('MDL and AIC plots against model order')
xlabel('Model order, p')
ylabel('Information Theoretic Criteria')
%% Filter white noise
P = 10;
N = numel(x0);
y = zeros(P, N);

for i = 1:10
    w = randn(1,N);  % Generate white noise to be filtered
    w(1) = x0(1);  % Initialise at sunspot data
    a = aryule(x0, i);
    y(i,:) = filter(1,a, w);
end

figure(3); clf; hold on;
plot(y(2,:))
plot(x0)
legend('Predicted', 'Real')

[a, vars] = aryule(x0, 2)
% Check fit with power spectrum
[H1, w1] = freqz(1, a);

figure(4); clf; hold on;
periodogram(x0)
hp = plot(w1/pi,20*log10(abs(H1).^2/(2*pi)),'r'); % Scale to make one-sided PSD
hp.LineWidth = 2;
xlabel('Normalized frequency (\times \pi rad/sample)')
ylabel('One-sided PSD (dB/rad/sample)')
legend('PSD estimate of x','PSD of model output')
periodogram(predictions(2,:))

%%
N = length(x0);
for order=1:15
    [ar_coeffs,loss_fuction] = aryule(x0, order);
    MDL(order) = log10(loss_fuction) + (order/N)*log10(N);
    AIC(order) = log10(loss_fuction) + (2*order)/N;
    L(order) = loss_fuction;
end

figure (4); clf;
set(gcf,'Color','w')
title('MDL and  AIC for the standardised sunspot series')
xlabel('Model Order')
hold on
plot(MDL)
plot(AIC, 'r')
plot(log10(L), 'g')

%% 2.3.5 Prediction Horizons

M = [1, 2, 5, 10];  % Prediction horizons
P = [1, 2, 10];  % Model Orders

clear all; close all; clc;

load('sunspot.dat')
sunspotdata = sunspot(:, 2);

% Take different order Yule Walker processes
a1 = aryule(sunspotdata,1);
a2 = aryule(sunspotdata,2);
a10 = aryule(sunspotdata,10);

% Due to the way MATLAB deals with filters, we have to sign reverse the
% coefficients before we can start (starting from 2 because coefficient 1 is always 1).
for i = 2:length(a1)
    a1(i) = -a1(i);
end
for i = 2:length(a2)
    a2(i) = -a2(i);
end
for i = 2:length(a10)
    a10(i) = -a10(i);
end

% We give our models the first 10 sets of data (or less for x1 and x2), but
% start from 10 and work back, so we can compare them all at the same point

x1 = sunspotdata(1:10);
x2 = sunspotdata(1:10);
x3 = sunspotdata(1:10);
x10 = sunspotdata(1:10);
actual = sunspotdata(1:20);

% In this for loop we apply our filters to the series of data

for i = 1:10
    x1(i+10) = a1(2)*x1(i+9);
    x2(i+10) = a2(2)*x2(i+9) + a2(3)*x2(i+8);
    x10(i+10) = a10(2)*x10(i+9) + a10(3)*x10(i+8) + a10(4)*x10(i+7) + a10(5)*x10(i+6) + a10(6)*x10(i+5) + a10(7)*x10(i+4) + a10(8)*x10(i+3) + a10(9)*x10(i+2) + a10(10)*x10(i+1) + a10(11)*x10(i);
end


figure;
hold on;
range = -9:10;
plot(range, x1);
plot(range, x2, 'c');
plot(range, x10, 'g');
plot(range, actual, 'r');
hold off;
    grid on;
    legend('AR(1)', 'AR(2)', 'AR(10)', 'Actual', 'Location', 'North');
    xlim([-9 10]);
    xlabel('Prediction Horizon (Years)');
    ylabel('No of Sunspots');
    title('Actual and Estimated Sunspots, based on varying order AR models');
