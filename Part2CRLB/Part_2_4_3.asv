% CRLB Heatmap i)
clc;

% Get estimate for true a1 coefficient
load NASDAQ.mat
prices = zscore(NASDAQ.Close);
[a, e, rc] = aryule(prices, 1);
a1 = -a(2);

% Get estimate for true rxx[0]
[rxx, lags] = xcorr(prices, 'unbiased');
rxx0 = rxx(lags==0);

n = 1:50:1001;
var = flip(1:50:1001);

% vGrid = 1./N.' * var.^2 .* 2;
% aGrid = 1./N.' * ones(size(var));

% figure(1); heatmap(vGrid);
% set(gca, 'ColorScale', 'log')
% figure(2); heatmap(aGrid);
% set(gca, 'ColorScale', 'log')

% varCRLB = 2 .* var.^2 ./N;

[N, VAR] = meshgrid(n, var);

vCRLB = 2 * VAR.^2 ./ N;
aCRLB = (1-a1^2) ./ N;
aCRLB_var = VAR ./ (N.*rxx0);

figure(1); clf;
h = heatmap(n, var, vCRLB);
h.ColorScaling = 'log';
h.Colormap = parula;
h.XLabel = 'N, number of samples';
h.YLabel = '$\sigma^{2}$, true variance of WGN';
h.Title = 'CRLB for $\hat{\sigma}^{2}$';
h.NodeChildren(3).XAxis.Label.Interpreter = 'latex';
h.NodeChildren(3).YAxis.Label.Interpreter = 'latex';
h.NodeChildren(3).Title.Interpreter = 'latex';

figure(2); clf;
h = heatmap(n, var, aCRLB);
h.ColorScaling = 'log';
h.Colormap = parula;
h.XLabel = 'N, number of samples';
h.YLabel = '$\sigma^{2}$, true variance of WGN';
h.Title = 'CRLB for $\hat{a}_{1}$';
h.NodeChildren(3).XAxis.Label.Interpreter = 'latex';
h.NodeChildren(3).YAxis.Label.Interpreter = 'latex';
h.NodeChildren(3).Title.Interpreter = 'latex';

figure(3); clf;
h = heatmap(n, var, aCRLB_var);
h.ColorScaling = 'log';
h.Colormap = parula;
h.XLabel = 'N, number of samples';
h.YLabel = '$\sigma^{2}$, true variance of WGN';
h.Title = 'CRLB for $\hat{a}_{1}$';
h.NodeChildren(3).XAxis.Label.Interpreter = 'latex';
h.NodeChildren(3).YAxis.Label.Interpreter = 'latex';
h.NodeChildren(3).Title.Interpreter = 'latex';

%% ii) var(a_hat_1)
% If using inbuilt, variance of input white noise
sprintf('In Built, Variance of input white noise: %f', e)

% In CW, sigma is true variance of driving noise
theoretical_var_process = e/(1-rxx(lags==1)/rxx(lags==0)*a1)
measured_var_process = std(prices)^2

% Assume var(a_hat_1) is CRLB
