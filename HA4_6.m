clc;clear
load('trainingdata.mat')
N = length(xt);
a1_hat = 137;
a2_hat = 0.004;
a3_hat = 120;
K = zeros(N,N);
sigma = 0.03;
% Build covariance matirx of training data
for k=1:N
    for l=1:N
        K(k,l)=a1_hat*exp(-a2_hat*sin(abs(xt(k)-xt(l))/a3_hat)^2); 
        if (k==l)
            K(k,l)=K(k,l)+sigma^2;
        end
    end
end

kk = a1_hat + sigma^2;
k_s = zeros(N,1);
f = zeros(length(-200:1000),1);
m = zeros(length(-200:1000),1);
variance = zeros(length(-200:1000),1);
i = 1;
for x=-200:1200
    % Covariance between observations and new input
    for k=1:N
        k_s(k) = a1_hat*exp(-a2_hat*sin(abs(xt(k)-x)/a3_hat)^2); 
    end
    meanValue = k_s'/K*(yt-mean(yt))' + mean(yt);
    variance(i) = kk - k_s'/K*k_s;
    f(i) = normrnd(meanValue,sqrt(variance(i)));
    m(i) = meanValue;
    i = i+1;
end

sd = sqrt(variance);
N = length(f);
M = 1000;
y = zeros(N,M);
for i=1:M
y(:,i) = f + sigma*randn(N,1);
end
xx = (-200:1200)';
figure
plot(xt,yt,'.');hold on
plot(xx,m);
shadedErrorBar(xx,m,sd+sigma,'-k',1); % Plotting deviation shadow
xlabel('input x')
title('Training Samples and Prediction')
legend('Training samples','mean of prediction')

