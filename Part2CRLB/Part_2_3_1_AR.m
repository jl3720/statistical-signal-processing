% Generate coefficient pairs
a1 = rand(100,1)*5 - 2.5;  % [-2.5,2.5]
a2 = rand(100,1)*3 - 1.5;  % [-1.5,1.5]

c1 = a1 + a2 < 1;
c2 = a2 - a1 < 1;
c3 = (a2 > -1) & (a2 < 1);
stable = c1 & c2 & c3;

figure(1); clf; hold on; grid on;

plot(a1(stable), a2(stable), '*')
plot([0 2], [1 -1], 'r')
plot([-2 0], [-1 1], 'r')
plot([-2 2], [-1 -1], 'r')

xlim([-3,3]); ylim([-3,3]);
legend('Stable coefficients', 'Stability triangle')
title('Plot of AR(2) coefficients resulting in convergent signals')
xlabel('First order AR coefficient, a_{1}')
ylabel('Second order AR coefficient, a_{2}')

% figure(2);
% scatter(a2,ones(100,1))
% scatter(a1,a2)

% Generate AR(2) realisations, would have to repeat 100 times and manually
% check for divergence?
% N = 1000;
% 
% x = zeros(N,1);
% x(1) = randn(1,1);  % Initialise w/ white noise
% x(2) = randn(1,1);
% 
% for i=3:1000
%     x(i) = a1(1)*x(i-1) + a2(1)*x(i-2) + randn(1,1);
% end
% 
% plot(x)

% plot(a1,a2,'*')