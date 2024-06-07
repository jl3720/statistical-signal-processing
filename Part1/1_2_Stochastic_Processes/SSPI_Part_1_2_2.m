% Ergodicity

% Generate realisations
M = 4;
N = 1000;

rand_proc1 = rp1(M, N);
rand_proc2 = rp2(M, N);
rand_proc3 = rp3(M, N);

time_avg1 = mean(rand_proc1, 2)  % Ensemble avg increases w/ time, this is 10 times longer than previous section
time_avg2 = mean(rand_proc2, 2)
time_avg3 = mean(rand_proc3, 2)

std1 = std(rand_proc1, 0, 2)
std2 = std(rand_proc2,0, 2)
std3 = std(rand_proc3,0, 2)