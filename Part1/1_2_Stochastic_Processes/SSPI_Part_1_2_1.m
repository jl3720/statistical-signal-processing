% 1.2.1 Compute ensemble mean and standard deviations

M = 100;  % Ensemble members
N = 100;  % Member length

% Generate random processes
rand_proc1 = rp1(M, N);
rand_proc2 = rp2(M, N);
rand_proc3 = rp3(M, N);

% Calc ensemble mean and std
avg1 = mean(rand_proc1, 1);  % Average across realisations for each time instant
avg2 = mean(rand_proc2, 1);
avg3 = mean(rand_proc3, 1);

std1 = std(rand_proc1, 1);
std2 = std(rand_proc2, 1);
std3 = std(rand_proc3, 1);

% Plot ensemble statistics over time

% Random Processes 1
fig1 = figure(1); clf;

subplot(2,1,1); plot(avg1, 'x');
xlabel('time, n');
ylabel('Ensemble mean');

subplot(2,1,2); plot(std1, 'x');
xlabel('time, n');
ylabel('Ensemble standard deviation');

sgtitle('Ensemble average and standard deviation over time for rp1')

% Random Processes 2
fig2 = figure(2); clf;

subplot(2,1,1); plot(avg2, 'x');
xlabel('time, n');
ylabel('Ensemble mean');

subplot(2,1,2); plot(std2, 'x');
xlabel('time, n');
ylabel('Ensemble standard deviation');

sgtitle('Ensemble average and standard deviation over time for rp2')

% Random Processes 3
fig3 = figure(3); clf;

subplot(2,1,1); plot(avg3, 'x');
xlabel('time, n');
ylabel('Ensemble mean');

subplot(2,1,2); plot(std3, 'x');
xlabel('time, n');
ylabel('Ensemble standard deviation');

sgtitle('Ensemble average and standard deviation over time for rp3')
