% 4.5 Speech recognition
fs = 44100;  % Sampling frequency

[e, efs] = audioread('e.m4a');
[a, afs] = audioread('a.m4a');
[s, sfs] = audioread('s.m4a');
[t, tfs] = audioread('t.m4a');
[x, xfs] = audioread('x.m4a');
disp(size(e))
%% Resample at sampling frequency
e = resample(e, fs, efs);
a = resample(a, fs, afs);
s = resample(s, fs, sfs);
t = resample(t, fs, tfs);
x = resample(x, fs, xfs);

%% Segment clips into N=1000 segments
e_seg = e(110000:110999);
% sound(e_seg, fs);

a_seg = a(56000:56999);
% sound(a_seg, fs);

s_seg = s(82000:82999);
% sound(s_seg, fs);

t_seg = t(77000:77999);
% sound(t_seg, fs);

x_seg = x(75000:75999);
% sound(x_seg,fs)

%% Get LSE for pth order predictor
p = 5;
mu = 0.1;
[xhat, err, weights] = lmsAR(e_seg, mu, p);

figure(1); clf;

subplot(1,2,1); hold on; grid on;

plot(weights(1,:))
plot(weights(2,:))
plot(weights(3,:))
plot(weights(4,:))
plot(weights(5,:))
% coefs = [-0.9 -0.2];
% bounds = 0.2 * coefs;
% yline([coefs+bounds, coefs-bounds], 'r--')

title('Time evolution of the estimated filter coefficients for \mu=0.01')
xlabel('Sample number')
ylabel('Adaptive weight values, \bf w[n]')
legend()

subplot(1,2,2);
gaus = gausswin(10, 1.5);
gaus = gaus/sum(gaus);
% plot(filter(gaus, 1,err.^2)); grid on;
plot(err.^2); grid on;

title('Time evolution for the squared estimation error for \mu=0.01')
xlabel('Sample number')
ylabel('Squared estimation error')

figure(2); clf; hold on; grid on;

plot(xhat)
plot(e_seg)
legend('Prediction', 'Recorded voice signal')
title('Prediction and recorded voice signal for predictor order 5')

%% Vary order and segment for plot
orders = [1,5,10];
letter_segs = [e_seg, a_seg, s_seg, t_seg, x_seg];
letters = ['e', 'a', 's', 't', 'x'];

for i=1:5
    letter = letters(i);
    seg = letter_segs(:,i);
    
    figure(); clf;
    t = tiledlayout(1,3);
    title(t, "Predictions compared to recorded '"+letter+"' signal for varying predictor order")
    xlabel(t, 'Sample number, n')
    ylabel(t, 'Signal value')
    
    for p=orders
        mu = 0.1;
        [xhat, err, weights] = lmsAR(seg, mu, p);
    
        nexttile; hold on;
%         plot(xhat./std(xhat))
%         plot(seg./std(seg))
        plot(xhat./std(xhat).*std(seg))
        plot(seg)
        legend('Prediction', 'Recorded voice signal', 'location', 'southwest', 'orientation', 'vertical')
        grid on;
        title(strcat('Model Order: ', num2str(p)))
    end
end

%% Vary order and segment for prediction gain
close all;
orders = [1:20];
letter_segs = [e_seg, a_seg, s_seg, t_seg, x_seg];
letters = ['e', 'a', 's', 't', 'x'];
err_var = zeros(5,20);
input_var = zeros(5,20);

for i=1:5
    letter = letters(i);
    seg = letter_segs(:,i);
    
    for p=orders
        mu = 0.1;
        [xhat, e_, weights] = lmsAR(seg, mu, p);
        xhat_correct = xhat./std(xhat).*std(seg);
        err = seg - xhat_correct';
        err_var(i,p) = var(err);
        input_var(i,p) = var(seg);
    
    end
end

Rp = 10*log10(input_var ./ err_var);

figure();
t = tiledlayout(1,5);
title(t, 'Prediction gain against model order for each letter')
xlabel(t, 'Prediction order, p'); ylabel(t, 'Prediction gain, R_{p}')

nexttile;
plot(Rp(1,:));
title('Letter "e"')
grid minor;

nexttile;
plot(Rp(2,:));
title('Letter "a"')
grid minor;

nexttile;
plot(Rp(3,:));
title('Letter "s"')
grid minor;

nexttile;
plot(Rp(4,:));
title('Letter "t"')
grid minor;

nexttile;
plot(Rp(5,:));
title('Letter "x"')
grid minor;

%% Repeat for fs=16000Hz
[e, efs] = audioread('e.m4a');
[a, afs] = audioread('a.m4a');
[s, sfs] = audioread('s.m4a');
[t, tfs] = audioread('t.m4a');
[x, xfs] = audioread('x.m4a');
%% Resample at sampling frequency
fs = 16000;
e = resample(e, fs, efs);
a = resample(a, fs, afs);
s = resample(s, fs, sfs);
t = resample(t, fs, tfs);
x = resample(x, fs, xfs);

%% Segment clips into N=1000 segments
e_seg = e(38000:38999);
sound(e_seg, fs);
%%
a_seg = a(22000:22999);
sound(a_seg, fs);
%%
s_seg = s(30000:30999);
sound(s_seg, fs);
%%
t_seg = t(28000:28999);
sound(t_seg, fs);
%%
x_seg = x(27000:27999);
sound(x_seg,fs)

%% Vary order and segment for prediction gain
close all;
orders = [1:20];
letter_segs = [e_seg, a_seg, s_seg, t_seg, x_seg];
letters = ['e', 'a', 's', 't', 'x'];
err_var = zeros(5,20);
input_var = zeros(5,20);

for i=1:5
    letter = letters(i);
    seg = letter_segs(:,i);
    
    for p=orders
        mu = 0.1;
        [xhat, e_, weights] = lmsAR(seg, mu, p);
        xhat_correct = xhat./std(xhat).*std(seg);
        err = seg - xhat_correct';
        err_var(i,p) = var(err);
        input_var(i,p) = var(seg);
    
    end
end

Rp = 10*log10(input_var ./ err_var);

figure();
t = tiledlayout(1,5);
title(t, 'Prediction gain against model order for each letter')
xlabel(t, 'Prediction order, p'); ylabel(t, 'Prediction gain, R_{p}')

nexttile;
plot(Rp(1,:));
title('Letter "e"')
grid minor;

nexttile;
plot(Rp(2,:));
title('Letter "a"')
grid minor;

nexttile;
plot(Rp(3,:));
title('Letter "s"')
grid minor;

nexttile;
plot(Rp(4,:));
title('Letter "t"')
grid minor;

nexttile;
plot(Rp(5,:));
title('Letter "x"')
grid minor;

%% Vary order and segment for plot
orders = [1,5,10];
letter_segs = [e_seg, a_seg, s_seg, t_seg, x_seg];
letters = ['e', 'a', 's', 't', 'x'];

for i=1:5
    letter = letters(i);
    seg = letter_segs(:,i);
    
    figure(); clf;
    t = tiledlayout(1,3);
    title(t, "Predictions compared to recorded '"+letter+"' signal for varying predictor order")
    xlabel(t, 'Sample number, n')
    ylabel(t, 'Signal value')
    
    for p=orders
        mu = 0.1;
        [xhat, err, weights] = lmsAR(seg, mu, p);
    
        nexttile; hold on;
%         plot(xhat./std(xhat))
%         plot(seg./std(seg))
        plot(xhat./std(xhat).*std(seg))
        plot(seg)
        legend('Prediction', 'Recorded voice signal', 'location', 'southwest', 'orientation', 'vertical')
        grid on;
        title(strcat('Model Order: ', num2str(p)))
    end
end