% 1.3.1 Estimate pdf

figure(1); clf;
N = 500;  % Number of samples
v = randn(1, N);
h = histogram(v, 'Normalization', 'pdf');
title('PDF estimate');
xlabel('x value')
ylabel('Probability density estimate')

