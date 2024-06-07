function [p, f] = pgm(x);
    L = length(x);
    X = fft(x);
    p_ = 1/L*abs(X).^2;
    p = p_(1:L/2);  % May need to deal with odd numbers
    f = [0:1/(L-1):0.5];
end