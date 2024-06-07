%% 3.3.3 LSE for AR(p) coefficient estimations
load sunspot.dat
x = zscore(sunspot(:,2));  % Standardised data
P = [1:10].';
E = zeros(P(end),1);
N = length(x);
A = zeros(P(end), P(end));
cost = zeros(P(end), 1);

figure(1); clf;
t = tiledlayout(5,2);
for p=1:10
    AR = ar(x, p, 'ls');  % Calculate AR system with LSE
    pred = compare(x, AR,1);  % Prediction horizon = 1
    error = sum((pred-x).^2);
    E(p) = error;
    cost(p) = AR.Report.Fit.LossFcn;
    A(p,1:p) = -getpvec(AR);  % Opposite convention for reporting

    % Plot standardised series
    nexttile; hold on;
    [a, v] = aryule(x,p);  % Standard series
    
    [H,w] = freqz(1,a, 512);
    P_model = abs(H).^2 .* v;  % Calculate model-based PSD
    plot(w/2/pi, 20*log10(P_model));  % Plot model based PSD of standard

    [prdgm, f] = pgm(x);
    plot(f(5:end), 20*log10(prdgm(5:end)))
    title(sprintf('Model Order: %i', p))
%     legend('Model-Based PSD', 'Periodogram', 'Location','southwest')
    grid on;
end
title(t, 'AR(p) Model-Based Power Spectra')
xlabel(t, 'Normalised frequency, f')
ylabel(t, 'PSD (dB)')
% legend(t, 'Model-Based PSD', 'Periodogram')
%% 3.3.4 Plot error 
figure();
plot(E);
title('Approximation Error for varying model order')
xlabel('Model order, p')
ylabel('Squared Prediciton Error')
%% MDL AIC Criteria
MDL = log(E) + P.*log(N)./N;
AIC = log(E) + 2.*P./N;
AICc = AIC + 2.*P.*(P + 1)./(N-P-1);

figure(2); clf; hold on;
plot(MDL, 'DisplayName', 'MDL')
plot(AIC, 'DisplayName', 'AIC')
plot(AICc, 'DisplayName', 'AICc')
plot(log(E), 'DisplayName', 'Cumulative Square Error, E')
legend('show'); grid on;
title('MDL and AIC plots against model order')
xlabel('Model order, p')
ylabel('Information Theoretic Criteria')

%% 3.3.6 Cost optimisation
figure(3);
plot(cost); grid on;
xlabel('Model order, p')
ylabel('Cost')
title('Cost function value for different model orders')
%% Effect of sample size
MSE = [];
% Based on elbow in cost function, p=2 optimal
for N=10:5:250
    AR = ar(x(1:N), 2, 'ls');  % Calculate AR system with LSE
    pred = compare(x(1:N), AR,1);  % Prediction horizon = 1
    MSE = [MSE; sum((pred-x(1:N)).^2)/N];
end
figure(4);
plot(10:5:250, MSE); grid on;
xlabel('Number of samples, N')
ylabel('MSE')
title('Approximation Error of AR(2) model for varying data length')
