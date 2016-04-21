N = 100;
x = randperm(N)';
x = x/norm(x/sqrt(2));
sigma = sqrt(10.^[-10:2]);
s = 0.01;
for ii = 1:1000
hI = sqrt(s)'*randn;
hQ = sqrt(s)'*randn;
h = hI + 1j*hQ;
len = length(sigma);
for i=1:len
    n = sigma(i)*(randn(N,1) + 1j*randn(N,1));
    y = h*x + n;
    % ML estimator
    h_ml(ii,i) = sum(y.*x)/sum(x.*x);
    var_ml(ii,i) = abs(h_ml(ii,i)-h)^2;
    
    % MAP estimator
    h_map(ii,i) = sum(y.*x)/(sum(x.*x)+2*sigma(i)^2/s);
    var_map(ii,i) = abs(real(h_map(ii,i))-real(h))^2 + abs(imag(h_map(ii,i))-imag(h))^2;
    % CRB
    crb(ii,i) = 2*sigma(i)^2/sum(x.*x);
    % BCRB
    bcrb(ii,i) = 2*s*sigma(i)^2/(s*sum(x.*x)+2*sigma(i)^2);
end
end
% figures
loglog(sigma.^2,mean(var_ml,1));hold on
loglog(sigma.^2,mean(var_map,1));hold on
loglog(sigma.^2,mean(crb,1));hold on
loglog(sigma.^2,mean(bcrb,1))
legend('Mean square error of ML estimator',...
    'Mean square error of MAP estimator',...
    'Cramer Rao bound','Bayesian Cramer Rao bound');
title('Estimator Performance versus Different Bounds');
xlabel('sigma^2');
ylabel('error variance');