function [xhat, err, weights] = lmsAR(x, mu, Nw)
    N = length(x);  % N, number of input and output signal samples x[1],...,x[N]
    xhat = zeros(1,N);  % Initialise output signal vectors
    err = zeros(1,N);
 
    w = zeros(Nw,1);  % Initial weights estimate
    weights = zeros(Nw,N);
    j = 1;
    for i = Nw+1:N
        x_section = x(i-1:-1:i-Nw);  % Try basing estimate off predicted x

%         disp('======================')
%         disp(i-1:-1:i-Nw);
%         disp(x_section); disp(w);
%         disp(size(x_section)); disp(size(w))

        xhat(i) = w.'*x_section;
        err(i) = x(i)-xhat(i);
        w = w+mu*err(i)*x_section;
        weights(:,j) = w;
        j = j+1;
    end
end