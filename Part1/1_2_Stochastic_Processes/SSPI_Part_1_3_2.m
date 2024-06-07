% Comparing estimate and theoretical pdfs

% Initialise constants
M = 1;
N = [100, 1000, 10000];

%% rp2

for i=1:3
    % Generate random processes of varying lengths
    rand_proc2 = rp2(M, N(i));
    rand_proc3 = rp3(M, N(i));
    
    figure();
    t=tiledlayout(1,2);
    title(t, strcat('N=', num2str(N(i))))

    nexttile;
    histogram(mean(rand_proc2,1), 100, 'Normalization','pdf');
    title('PDF for rp2')

    nexttile;
    histogram(mean(rand_proc3,1), 100, 'Normalization','pdf');
    title('PDF for rp3')
end
