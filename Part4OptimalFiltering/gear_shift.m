function [y, err, weights] = lms(x, z, mu0, Nw)
    N = length(x);  % N, number of input and output signal samples x[1],...,x[N]
    y = zeros(1,N);  % Initialise output signal vectors
    err = zeros(1,N);
    mu = mu0;  % initialise adaptive gain
 
    w = zeros(Nw+1,1);  % Initial weights estimate
    weights = zeros(Nw+1,N);
    j = 1;
    for i = Nw+1:N
        x_section = x(i:-1:i-Nw);
        y(i) = w.'*x_section;
        err(i) = z(i)-y(i);
%         if err(i)<err(i-1)
%             mu = mu*0.8;
%         else
%             mu = mu*1.2;
%         end
        if abs(err(i)) > 0.6 
            mu = mu*1.2;
        elseif abs(err(i)) < 0.05  % target error
            mu = mu*0.8;
        end
        w = w+mu.*err(i).*x_section;
        weights(:,j) = w;
        j = j+1;
    end
end