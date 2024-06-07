% 4.1 Wiener Filter

%% 4.1.1

x = randn(1000,1);  % WGN 1000 x 1 column vector

b = [1,2,3,2,1];
a = [1];
y_ = filter(b,a,x);  % Deterministic MA signal y[n]
y = y_ / std(y_);  % Unit variance y[n]
noise = randn(1000,1).*sqrt(0.1);
z = y + noise; % Add noise with variance 0.1
SNR = var(y)^2/0.1  % SNR = Ratio of power sig:noise = Ratio of var for zero mean white noise

% Get statistics
order = 4;
[R, Rlags] = xcorr(x, order,'unbiased');  
[p, plags] = xcorr(z,x, order, 'unbiased');     
R_xx = R(1+order:(2*order)+1);
R_xx = toeplitz(R_xx);   
p_zx = p(1+order:(2*order)+1);   

wopt = inv(R_xx)*p_zx .* sqrt(sum(b.*b))

%% Repeat for different noise
vars = logspace(-1, 1, 6);
SNR = [];
W = [];
i=1;
for v=vars
    noise = randn(1000,1) .* sqrt(v);
    z = y + noise;
    SNR = [SNR var(y)/v];

    order = 4;
    [R, Rlags] = xcorr(x, order,'unbiased');  
    [p, plags] = xcorr(z,x, order, 'unbiased');     
    R_xx = R(1+order:(2*order)+1);
    R_xx = toeplitz(R_xx);   
    p_zx = p(1+order:(2*order)+1);   
    
    wopt = inv(R_xx)*p_zx .* sqrt(sum(b.*b));
    W(i,:) = wopt;
    i = i+1;
end
W
vars
SNRdB =20*log10(SNR)

%% Repeat for different model order
W = zeros(4,10);
i=1;
v = 0.1;
orders = [4, 5, 6, 10];
for order = orders;
    noise = randn(1000,1) .* sqrt(v);
    z = y + noise;

    [R, Rlags] = xcorr(x, order,'unbiased');  
    [p, plags] = xcorr(z,x, order, 'unbiased');     
%     R_xx = R(1+order:(2*order)+1);
    R_xx = R(ismember(Rlags, 0:order))
    R_xx = toeplitz(R_xx);   
    p_zx = p(ismember(plags, 0:order));   
    
    wopt = inv(R_xx)*p_zx .* sqrt(sum(b.*b));
    W(i,1:order+1) = wopt;
    i = i+1;
end
W


