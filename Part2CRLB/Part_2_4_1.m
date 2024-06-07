% 2.4 Cramer Rao Lower Bound

%% 2.4.1 AR model i

load NASDAQ.mat
prices = zscore(NASDAQ.Close);

% Generate PCF
P = 10;
N = numel(prices);
AC = zeros(P,P);  % Store AC coefficients

for p=1:P
    a_matlab = aryule(prices, p);
    a = -a_matlab(2:end);
    AC(p,1:p) = a;
end

PAC = zeros(1,P);
for i=1:P
    PAC(i) = AC(i,i);
end

clf; s = stem(PAC); hold on;
s.LineWidth = 0.7;
s.Color = 'k';
plot(1.96/sqrt(N).*[ones(1,10)], 'r--')
plot(-1.96/sqrt(N).*[ones(1,10)], 'r--')
xlabel('Model i'); ylabel('PCF')
title('Partial ACF up to i p=10'); grid on;
legend('PCF coefficients', '95% Confidence Intervals')

% Check AIC and MDL
N = length(prices);
P = 10;
MDL = zeros(1,P);
AIC = zeros(1,P);
p = [1:10].';

for i=1:10
    [ar_coeffs,loss_fuction] = aryule(prices, i);
    MDL(i) = log10(loss_fuction) + (i/N)*log10(N);
    AIC(i) = log10(loss_fuction) + (2*i)/N;
end

AICc = AIC.' + 2.*p.*(p + 1)./(N-p-1);

figure(2); clf;
set(gcf,'Color','w')
title('MDL and AIC for standardised NASDAQ closing prices')
xlabel('Model order, p')
ylabel('Information Theoretic Criteria')
hold on; grid on;
plot(MDL, 'DisplayName', 'MDL')
plot(AIC, 'r', 'DisplayName', 'AIC')
plot(AICc, 'g', 'DisplayName', 'AICc')
legend('show')