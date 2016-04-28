clc;clear
%% Generate observation samples
K = 3; % Number of components
N = 2000; % Sample size
% Gaussian mixture distribution
X = linspace(-6,6,100)';
load('DataLog.mat');

%% Gibbs Sampling
alpha = 1;
s = 1;
% Parameter initialization
z = zeros(N,1);
Epi = zeros(K,1);
Pr = zeros(K,1);
summ = zeros(K,1);
Pi = zeros(K,1);
% Initial distribution of mean values and weights
nz = [500;1000;500]; % Choose an initial z
mu_k = randn(3,1);
plot(x,zeros(N,1),'ro');hold on
title('A Gaussian mixture PDF and a few samples');

% Markov chain Monte Carlo
for j=1:1000
    for i=1:N
        for k=1:K
            % Conditional probability on z_i=k
            Epi(k) = (alpha/K+nz(k))/(alpha+N-1);
            Pr(k) = Epi(k)*normpdf(x(i),mu_k(k),1);
        end
        Pr = Pr/sum(Pr);
        z(i) = randsample(1:K,1,true,Pr); % Sample z
    end
    for k=1:K
        % Find number of observations belong to the kth compoment
        nz(k) = length(find(z==k));
        summ(k) = sum(x(z==k));
        mu_k(k) = summ(k)/nz(k);
        Pi(k) = nz(k)/N;
    end
end
sigma = cat(3,1,1,1); % Variance
newObj = gmdistribution(mu_k,sigma,Pi'); % Estimated model
newPdf = pdf(newObj,X); % Estimated pdf
plot(X,newPdf,'Linewidth',2); hold on
xlabel('Observations');
legend('Observation samples','PDF of estimated model','Location','NorthWest');
